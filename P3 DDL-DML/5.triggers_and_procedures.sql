-- Trigger to insert units into the UNIT table after a warehouse is created
SET SERVEROUTPUT ON
/
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

-- Trigger to update the available space in the warehouse after a lease is created

CREATE OR REPLACE TRIGGER insert_lease_units
AFTER INSERT ON LEASE
FOR EACH ROW
BEGIN
    -- Calling the procedure to update warehouse  and units
    update_lease_information(:new.Warehouse_ID, :new.Units_leased, :new.Lease_ID);
END;
/


CREATE OR REPLACE PROCEDURE update_lease_information(
    p_warehouse_id IN VARCHAR2,
    p_units_leased IN NUMBER,
    p_lease_id IN VARCHAR2
) AS
    CURSOR c_units IS
        SELECT UNIT_ID
        FROM UNIT
        WHERE WAREHOUSE_ID = p_warehouse_id
        AND AVAILABILITY_STATUS = 'A'
        AND ROWNUM <= p_units_leased;
    l_unit_id UNIT.UNIT_ID%TYPE;
BEGIN
    -- Update warehouse's available space
    UPDATE WAREHOUSE
    SET AVAILABLE_SPACE = AVAILABLE_SPACE - p_units_leased
    WHERE WAREHOUSE_ID = p_warehouse_id;

    -- Update units' availability status and insert records into lease_units table
    FOR unit_rec IN c_units LOOP
        BEGIN
            -- Update unit's availability status to 'NA'
            UPDATE UNIT
            SET AVAILABILITY_STATUS = 'NA'
            WHERE UNIT_ID = unit_rec.UNIT_ID;
            
            -- Insert record into LEASE_UNIT table
            INSERT INTO LEASE_UNIT (Lease_Unit_ID, Unit_ID, Lease_ID)
            VALUES (Lease_Unit_ID_SEQ.NEXTVAL, unit_rec.UNIT_ID, p_lease_id);
            
            -- Store the unit ID for debugging or further processing
            l_unit_id := unit_rec.UNIT_ID;
            DBMS_OUTPUT.PUT_LINE('Inserted Lease_Unit record for Unit_ID: ' || l_unit_id);
        EXCEPTION
            WHEN OTHERS THEN
                -- Handle exceptions (e.g., rollback changes, log errors)
                DBMS_OUTPUT.PUT_LINE('Error processing unit ' || unit_rec.UNIT_ID || ': ' || SQLERRM);
                -- You can add additional error handling logic here
        END;
    END LOOP;
END;
/

CREATE OR REPLACE FUNCTION calculate_lease_amount(
    p_start_date IN DATE,
    p_end_date IN DATE,
    p_zip_code IN VARCHAR2,
    p_required_units IN NUMBER,
    p_warehouse_type IN VARCHAR2
) RETURN VARCHAR2
IS
    v_monthly_rate NUMBER;
    v_warehouse_id VARCHAR2(50);
    v_lease_amount NUMBER;
    v_months NUMBER;
BEGIN
    -- Finding a suitable warehouse for the lease
    SELECT wt.Monthly_Rate, w.Warehouse_ID
    INTO v_monthly_rate, v_warehouse_id
    FROM WAREHOUSE w
    JOIN WAREHOUSE_TYPE wt ON w.Warehouse_Type_ID = wt.Warehouse_Type_ID
    JOIN LOCATION loc ON w.Location_ID = loc.Location_ID
    WHERE loc.ZIP = p_zip_code
    AND wt.Type_Name = p_warehouse_type
    AND w.Available_Space >= p_required_units
    AND NOT EXISTS (
        SELECT 1
        FROM LEASE l
        WHERE l.Warehouse_ID = w.Warehouse_ID
        AND (p_start_date BETWEEN l.Start_Date AND l.End_Date
        OR p_end_date BETWEEN l.Start_Date AND l.End_Date)
    )
    AND ROWNUM = 1; -- Selecting only one suitable warehouse

    -- Calculate the number of months between start and end dates
    SELECT MONTHS_BETWEEN(p_end_date, p_start_date)
    INTO v_months
    FROM dual;
    
    IF v_months < 1 THEN
        v_months := 1;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('v_months: ' || v_months);
    DBMS_OUTPUT.PUT_LINE('v_monthly_rate: ' || v_monthly_rate);


    v_lease_amount := ROUND(v_months * v_monthly_rate,2);
    
    RETURN v_warehouse_id || ',' || TO_CHAR(v_lease_amount*p_required_units);
END calculate_lease_amount;
/

CREATE OR REPLACE PROCEDURE process_payment(
    p_lease_id IN VARCHAR2,
    p_transaction_date IN TIMESTAMP,
    p_payment_mode IN VARCHAR2,
    p_transaction_amount IN NUMBER
) AS
    v_balance_amount NUMBER;
BEGIN
    -- Updating payment status and balance amount in the LEASE table
    SELECT Balance_Amount - p_transaction_amount INTO v_balance_amount
    FROM LEASE
    WHERE Lease_ID = p_lease_id;

    IF v_balance_amount < 0 THEN
        v_balance_amount := 0;
    END IF;
    DBMS_OUTPUT.PUT_LINE('v_balance_amount: ' || v_balance_amount);
    UPDATE LEASE
    SET Payment_Status = CASE
                            WHEN v_balance_amount = 0 THEN 'PAID'
                            ELSE 'PARTIAL'
                         END,
        Balance_Amount = v_balance_amount
    WHERE Lease_ID = p_lease_id;

    -- Insert payment record into the PAYMENT table
    INSERT INTO PAYMENT (Lease_ID, Transaction_Date, Payment_Mode, Transaction_Amount)
    VALUES (p_lease_id, p_transaction_date, p_payment_mode, p_transaction_amount);

   COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error processing payment: ' || SQLERRM);
END;
/