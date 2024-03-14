CREATE OR REPLACE TRIGGER insert_warehouse_units_trigger
AFTER INSERT ON WAREHOUSES
FOR EACH ROW
DECLARE
    num_units NUMBER;
BEGIN
   
    num_units := :new.Available_Space;

    FOR i IN 1..num_units LOOP
        INSERT INTO UNITS (Unit_ID, Warehouse_ID, Availability_Status)
        VALUES (Unit_ID_SEQ.NEXTVAL, :new.Warehouse_ID, 'A');
    END LOOP;
END;

/


