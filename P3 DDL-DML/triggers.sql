CREATE OR REPLACE TRIGGER insert_warehouse_units_trigger
AFTER INSERT ON WAREHOUSE
FOR EACH ROW
DECLARE
    num_units NUMBER;
BEGIN
   
    num_units := :new.Available_Space;

    FOR i IN 1..num_units LOOP
        INSERT INTO UNIT (Unit_ID, Warehouse_ID, Availability_Status)
        VALUES (Unit_ID_SEQ.NEXTVAL, :new.Warehouse_ID, 'A');
    END LOOP;
END;

/

CREATE OR REPLACE TRIGGER insert_lease_units
AFTER INSERT ON LEASE
FOR EACH ROW
DECLARE
    v_unit_id VARCHAR2(50);
BEGIN
    FOR i IN 1..:NEW.Units_leased LOOP
        -- Get available unit ID from UNITS table for the corresponding warehouse
        SELECT Unit_ID INTO v_unit_id
        FROM UNIT
        WHERE Warehouse_ID = :NEW.Warehouse_ID
        AND Availability_Status = 'A'
        AND ROWNUM = 1; -- Select only one available unit
        
        -- Insert into LEASE_UNITS table
        INSERT INTO LEASE_UNIT (Lease_ID, Unit_ID)
        VALUES (:NEW.Lease_ID, v_unit_id);
    END LOOP;
END;
/


