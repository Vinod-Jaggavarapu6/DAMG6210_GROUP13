PURGE RECYCLEBIN;
SET SERVEROUTPUT ON;


-- Trigger to insert units (based on warehouse space provided when creating a new warehouse) into the UNIT table after a warehouse is created

CREATE OR REPLACE TRIGGER insert_warehouse_units_trigger
AFTER INSERT ON WAREHOUSE
FOR EACH ROW
DECLARE
    num_units WAREHOUSE.AVAILABLE_SPACE%TYPE;
BEGIN
   
    num_units := :new.Available_Space;

    FOR i IN 1..num_units LOOP
        INSERT INTO UNIT (Unit_ID, Warehouse_ID, Availability_Status)
        VALUES (Unit_ID_SEQ.NEXTVAL, :new.Warehouse_ID, 'A'); -- A for available (default status)
    END LOOP;
END;

/


-- Procedure to update warehouse's available space and units' availability status  and inserting into lease_units after a lease is created

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
        AND ROWNUM <= p_units_leased; -- cursor to select available units for lease
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
            
            -- unit ID for debugging
            l_unit_id := unit_rec.UNIT_ID;
            DBMS_OUTPUT.PUT_LINE('Inserted Lease_Unit record for Unit_ID: ' || l_unit_id);
        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK;
                DBMS_OUTPUT.PUT_LINE('Error processing unit ' || unit_rec.UNIT_ID || ': ' || SQLERRM);
        END;
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

-- Function to calculate the lease amount based on customer requirements and warehouse availability
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
    END IF; -- Minimum lease period is 1 month (business rule)
    
    DBMS_OUTPUT.PUT_LINE('v_months: ' || v_months);
    DBMS_OUTPUT.PUT_LINE('v_monthly_rate: ' || v_monthly_rate);


    v_lease_amount := ROUND(v_months * v_monthly_rate,2);
    
    RETURN v_warehouse_id || ',' || TO_CHAR(v_lease_amount*p_required_units);
END calculate_lease_amount;
/

-- Procedure to process payment and update payment status and balance amount in the LEASE table
-- CREATE OR REPLACE PROCEDURE process_payment(
--     p_lease_id IN VARCHAR2,
--     p_transaction_date IN TIMESTAMP,
--     p_payment_mode IN VARCHAR2,
--     p_transaction_amount IN NUMBER
-- ) AS
--     v_balance_amount NUMBER;
-- BEGIN
--     -- Updating payment status and balance amount in the LEASE table
--     SELECT Balance_Amount - p_transaction_amount INTO v_balance_amount
--     FROM LEASE
--     WHERE Lease_ID = p_lease_id;

--     IF v_balance_amount < 0 THEN
--         v_balance_amount := 0;
--     END IF;
--     DBMS_OUTPUT.PUT_LINE('v_balance_amount: ' || v_balance_amount);
--     UPDATE LEASE
--     SET Payment_Status = CASE
--                             WHEN v_balance_amount = 0 THEN 'PAID'
--                             ELSE 'PARTIAL'
--                          END,
--         Balance_Amount = v_balance_amount
--     WHERE Lease_ID = p_lease_id;

--     -- Insert payment record into the PAYMENT table
--     INSERT INTO PAYMENT (Lease_ID, Transaction_Date, Payment_Mode, Transaction_Amount)
--     VALUES (p_lease_id, p_transaction_date, p_payment_mode, p_transaction_amount);

--    COMMIT;
-- EXCEPTION
--     WHEN OTHERS THEN
--         ROLLBACK;
--         DBMS_OUTPUT.PUT_LINE('Error processing payment: ' || SQLERRM);
-- END;
-- /

-- Procedure to process payment and update payment status and balance amount in the LEASE table
CREATE OR REPLACE PROCEDURE process_payment(
    p_lease_id IN VARCHAR2,
    p_transaction_date IN TIMESTAMP,
    p_payment_mode IN VARCHAR2,
    p_transaction_amount IN NUMBER
) AS
    v_balance_amount NUMBER;
BEGIN
    -- Check if lease exists and if it's already paid in full
    SELECT Balance_Amount INTO v_balance_amount
    FROM LEASE
    WHERE Lease_ID = p_lease_id;

    IF v_balance_amount <= 0 THEN
        DBMS_OUTPUT.PUT_LINE('Cannot process the paymnet as This lease'|| p_lease_id||' is already paid in full.');
        RETURN;
    END IF;

    -- Calculate new balance amount after payment
    v_balance_amount := v_balance_amount - p_transaction_amount;

    -- Check if the transaction amount exceeds the remaining balance
    IF v_balance_amount < 0 THEN
        DBMS_OUTPUT.PUT_LINE('Cannot process the payment as the Transaction amount exceeds the remaining balance to be paid.');
        RETURN;
    END IF;

    -- Update payment status and balance amount in the LEASE table
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
    DBMS_OUTPUT.PUT_LINE('Payment processed successfully.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('No lease found with the given Lease_ID');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error processing payment: ' || SQLERRM);
END;
/

-- Procedure to insert a customer record
CREATE OR REPLACE PROCEDURE InsertCustomer (
    p_First_Name CUSTOMER.First_Name%TYPE,
    p_Last_Name CUSTOMER.Last_Name%TYPE,
    p_Customer_Address CUSTOMER.Customer_Address%TYPE,
    p_Email CUSTOMER.Email%TYPE,
    p_Phone CUSTOMER.Phone%TYPE
)
IS
BEGIN
    INSERT INTO CUSTOMER (Customer_ID, First_Name, Last_Name, Customer_Address, Email, Phone)
    VALUES (Customer_ID_SEQ.NEXTVAL, p_First_Name, p_Last_Name, p_Customer_Address, p_Email, p_Phone);
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Customer '|| p_First_Name || ' ' || p_Last_Name || ' inserted successfully');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Customer '|| p_First_Name || ' ' || p_Last_Name || ' already exists');
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Invalid input');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END InsertCustomer;
/

-- Procedure to insert a location record
CREATE OR REPLACE PROCEDURE InsertLocation (
    p_ZIP LOCATION.ZIP%TYPE,
    p_City LOCATION.City%TYPE,
    p_State LOCATION.State%TYPE,
    p_Country LOCATION.Country%TYPE
)
IS
BEGIN
    INSERT INTO LOCATION (Location_ID, ZIP, City, State, Country)
    VALUES (Location_ID_SEQ.NEXTVAL, p_ZIP, p_City, p_State, p_Country);
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Location with ZIP '|| p_ZIP || ' inserted successfully');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Location with ZIP '|| p_ZIP || ' already exists');
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Invalid input');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END InsertLocation;
/

-- Procedure to insert a warehouse type record
CREATE OR REPLACE PROCEDURE InsertWarehouseType (
    p_Type_Name WAREHOUSE_TYPE.Type_Name%TYPE,
    p_Monthly_Rate WAREHOUSE_TYPE.Monthly_Rate%TYPE
)
IS
BEGIN
    INSERT INTO WAREHOUSE_TYPE (Warehouse_Type_ID, Type_Name, Monthly_Rate)
    VALUES (Warehouse_Type_ID_SEQ.NEXTVAL, p_Type_Name, p_Monthly_Rate);
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Warehouse Type '|| p_Type_Name || ' inserted successfully');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Warehouse Type '|| p_Type_Name || ' already exists');
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Invalid input');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END InsertWarehouseType;
/

-- Procedure to insert a warehouse owner record
CREATE OR REPLACE PROCEDURE InsertWarehouseOwner (
    p_Owner_Name WAREHOUSE_OWNER.Owner_Name%TYPE,
    p_Owner_Address WAREHOUSE_OWNER.Owner_Address%TYPE,
    p_Email WAREHOUSE_OWNER.Email%TYPE,
    p_Phone WAREHOUSE_OWNER.Phone%TYPE
)
IS
BEGIN
    INSERT INTO WAREHOUSE_OWNER (Owner_ID, Owner_Name, Owner_Address, Email, Phone)
    VALUES (Owner_ID_SEQ.NEXTVAL, p_Owner_Name, p_Owner_Address, p_Email, p_Phone);
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Warehouse Owner '|| p_Owner_Name || ' inserted successfully');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Warehouse Owner '|| p_Owner_Name || ' already exists');
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Invalid input');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END InsertWarehouseOwner;
/

-- Procedure to insert a warehouse record
CREATE OR REPLACE PROCEDURE InsertWarehouse (
    p_Warehouse_Name WAREHOUSE.Warehouse_Name%TYPE,
    p_Address WAREHOUSE.Address%TYPE,
    p_Available_Space WAREHOUSE.Available_Space%TYPE,
    p_Warehouse_Type_ID WAREHOUSE.Warehouse_Type_ID%TYPE,
    p_Location_ID WAREHOUSE.Location_ID%TYPE,
    p_Owner_ID WAREHOUSE.Owner_ID%TYPE,
    p_Location_LAT WAREHOUSE.Location_LAT%TYPE,
    p_Location_LONG WAREHOUSE.Location_LONG%TYPE
)
IS
BEGIN
    INSERT INTO WAREHOUSE (Warehouse_ID, Warehouse_Name, Address, Available_Space, Warehouse_Type_ID, Location_ID, Owner_ID, Location_LAT, Location_LONG)
    VALUES (Warehouse_ID_SEQ.NEXTVAL, p_Warehouse_Name, p_Address, p_Available_Space, p_Warehouse_Type_ID, p_Location_ID, p_Owner_ID, p_Location_LAT, p_Location_LONG);
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Warehouse '|| p_Warehouse_Name || ' inserted successfully');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Warehouse '|| p_Warehouse_Name || ' already exists');
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Invalid input');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END InsertWarehouse;
/

-- Procedure to insert a warehouse employee record
CREATE OR REPLACE PROCEDURE InsertWarehouseEmployee (
    p_Warehouse_ID WAREHOUSE_EMPLOYEE.Warehouse_ID%TYPE,
    p_Employee_Name WAREHOUSE_EMPLOYEE.Employee_Name%TYPE,
    p_Address WAREHOUSE_EMPLOYEE.Address%TYPE,
    p_Email WAREHOUSE_EMPLOYEE.Email%TYPE,
    p_Phone WAREHOUSE_EMPLOYEE.Phone%TYPE,
    p_Role WAREHOUSE_EMPLOYEE.Role%TYPE,
    p_Salary WAREHOUSE_EMPLOYEE.Salary%TYPE
)
IS
BEGIN
    INSERT INTO WAREHOUSE_EMPLOYEE (Employee_ID, Warehouse_ID, Employee_Name, Address, Email, Phone, Role, Salary)
    VALUES (Employee_ID_SEQ.NEXTVAL, p_Warehouse_ID, p_Employee_Name, p_Address, p_Email, p_Phone, p_Role, p_Salary);
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Employee '|| p_Employee_Name || ' inserted successfully');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Employee '|| p_Employee_Name || ' already exists');
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Invalid input');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END InsertWarehouseEmployee;
/

-- Procedure to insert a lease record
CREATE OR REPLACE PROCEDURE InsertLease (
    p_Warehouse_ID LEASE.Warehouse_ID%TYPE,
    p_Customer_ID LEASE.Customer_ID%TYPE,
    p_Start_Date DATE DEFAULT SYSDATE,
    p_End_Date DATE DEFAULT ADD_MONTHS(SYSDATE, 1),
    p_Lease_Amount LEASE.Lease_Amount%TYPE,
    p_Units_leased LEASE.Units_leased%TYPE
)
IS
BEGIN
    INSERT INTO LEASE (Lease_ID, Warehouse_ID, Customer_ID, Start_Date, End_Date, Lease_Amount,  Balance_Amount, Units_leased)
    VALUES (Lease_ID_SEQ.NEXTVAL, p_Warehouse_ID, p_Customer_ID, p_Start_Date, p_End_Date, p_Lease_Amount, p_Lease_Amount, p_Units_leased);
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Lease inserted successfully');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Lease already exists');
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Invalid input');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END InsertLease;
/

-- Procedure to insert a service request record
CREATE OR REPLACE PROCEDURE InsertServiceRequest (
    p_Lease_Unit_ID SERVICE_REQUEST.Lease_Unit_ID%TYPE,
    p_Request_Desc SERVICE_REQUEST.Request_Desc%TYPE,
    p_Customer_ID SERVICE_REQUEST.Customer_ID%TYPE
)
IS
BEGIN
    INSERT INTO SERVICE_REQUEST (Request_ID, Lease_Unit_ID, Request_Desc, Customer_ID)
    VALUES (Service_Request_ID_SEQ.NEXTVAL, p_Lease_Unit_ID, p_Request_Desc, p_Customer_ID);
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Service request inserted successfully');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Service request already exists');
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Invalid input');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END InsertServiceRequest;
/
