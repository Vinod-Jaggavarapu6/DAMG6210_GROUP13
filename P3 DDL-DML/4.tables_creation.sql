SET SERVEROUTPUT ON;
--script to create tables 

CREATE OR REPLACE PROCEDURE create_tables AS
    e_code NUMBER;
    e_msg VARCHAR2(255);
BEGIN
-- create table CUSTOMER
    BEGIN
    
        EXECUTE IMMEDIATE 'CREATE TABLE CUSTOMER (
            Customer_ID VARCHAR2(50) DEFAULT Customer_ID_SEQ.NEXTVAL,   
            First_Name VARCHAR2(50) NOT NULL,
            Last_Name VARCHAR2(50) NOT NULL,
            Customer_Address VARCHAR2(100),
            Email VARCHAR2(50) NOT NULL,
            Phone VARCHAR2(10) NOT NULL,
            CONSTRAINT C_Customer_ID_PK PRIMARY KEY (Customer_ID),
            CONSTRAINT C_Customer_Email_UNIQUE UNIQUE (Email),
            CONSTRAINT C_Customer_Email_CHECK CHECK (Email LIKE ''%_@__%.%__%''),
            CONSTRAINT C_Customer_Phone_CHECK CHECK (LENGTH(Phone) = 10) 
        )';
        dbms_output.put_line('Table CUSTOMER created successfully.');
    EXCEPTION
        WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            dbms_output.put_line('Table CUSTOMER already exists.');
        ELSE
            dbms_output.put_line(SQLERRM);
        END IF;
    END;
-- create table LOCATION
    BEGIN
        EXECUTE IMMEDIATE 'CREATE TABLE LOCATION (
            Location_ID VARCHAR2(50) DEFAULT Location_ID_SEQ.NEXTVAL,
            ZIP VARCHAR2(5) NOT NULL,
            City VARCHAR2(50) NOT NULL,
            State VARCHAR2(25) NOT NULL,
            Country VARCHAR2(50) NOT NULL,
            CONSTRAINT C_Location_ID_PK PRIMARY KEY (Location_ID),
            CONSTRAINT C_Location_ZIP_UNIQUE UNIQUE (ZIP)
        )';
    EXCEPTION
        WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            dbms_output.put_line('Table LOCATION already exists.');
        ELSE
            dbms_output.put_line(SQLERRM);
        END IF;
    END;
-- create table WAREHOUSE_TYPE
    BEGIN
        EXECUTE IMMEDIATE 'CREATE TABLE WAREHOUSE_TYPE (
            Warehouse_Type_ID VARCHAR2(50) DEFAULT Warehouse_Type_ID_SEQ.NEXTVAL,
            Type_Name VARCHAR2(50) NOT NULL,
            Monthly_Rate NUMBER(10, 2) NOT NULL,
            CONSTRAINT C_Warehouse_Type_ID_PK PRIMARY KEY (Warehouse_Type_ID)
        )';
    EXCEPTION
        WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            dbms_output.put_line('Table WAREHOUSE_TYPE already exists.');
        ELSE
            dbms_output.put_line(SQLERRM);
        END IF;
    END;
-- create table WAREHOUSE_OWNER
    BEGIN
        EXECUTE IMMEDIATE 'CREATE TABLE WAREHOUSE_OWNER (
            Owner_ID VARCHAR2(50) DEFAULT Owner_ID_SEQ.NEXTVAL,
            Owner_Name VARCHAR2(100) NOT NULL,
            Owner_Address VARCHAR2(100),
            Email VARCHAR2(50) NOT NULL,
            Phone VARCHAR2(15) NOT NULL,
            CONSTRAINT C_Owner_ID_PK PRIMARY KEY (Owner_ID),
            CONSTRAINT C_Owner_Email_UNIQUE UNIQUE (Email),
            CONSTRAINT C_Owner_Email_CHECK CHECK (Email LIKE ''%_@__%.%__%'')
        )';
    
    EXCEPTION
        WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            dbms_output.put_line('Table WAREHOUSE_OWNER already exists.');
        ELSE
            dbms_output.put_line(SQLERRM);
        END IF;
            
    END;
-- create table WAREHOUSE
    BEGIN 
        EXECUTE IMMEDIATE 'CREATE TABLE WAREHOUSE (
            Warehouse_ID VARCHAR2(50) DEFAULT Warehouse_ID_SEQ.NEXTVAL,
            Warehouse_Name VARCHAR2(50) NOT NULL,
            Address VARCHAR2(100),
            Available_Space NUMBER(5) NOT NULL,
            Warehouse_Type_ID VARCHAR2(50),
            Location_ID VARCHAR2(50) ,
            Owner_ID VARCHAR2(50) NOT NULL,
            Location_LAT DECIMAL(8, 6),
            Location_LONG DECIMAL(9, 6),
            CONSTRAINT C_Warehouse_ID_PK PRIMARY KEY (Warehouse_ID),
            CONSTRAINT C_Warehouse_WarehouseType_ID_FK FOREIGN KEY (Warehouse_Type_ID) REFERENCES WAREHOUSE_TYPE(Warehouse_Type_ID),
            CONSTRAINT C_Warehouse_Location_ID_FK FOREIGN KEY (Location_ID) REFERENCES LOCATION(Location_ID),
            CONSTRAINT C_Warehouse_Owner_ID_FK FOREIGN KEY (Owner_ID) REFERENCES  WAREHOUSE_OWNER(Owner_ID)
        )';
    EXCEPTION
        WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            dbms_output.put_line('Table WAREHOUSE already exists.');
        ELSE
            dbms_output.put_line(SQLERRM);
        END IF;
    END;
-- create table WAREHOUSE_EMPLOYEE
    BEGIN 
        EXECUTE IMMEDIATE 'CREATE TABLE WAREHOUSE_EMPLOYEE (
            Employee_ID VARCHAR2(50) DEFAULT Employee_ID_SEQ.NEXTVAL,
            Warehouse_ID VARCHAR2(50),
            Employee_Name VARCHAR2(100) NOT NULL,
            Address VARCHAR2(100),
            Email VARCHAR2(50) NOT NULL,
            Phone VARCHAR2(15) NOT NULL,
            Role VARCHAR2(20) NOT NULL,
            Salary NUMBER(8, 2),
            CONSTRAINT C_Employee_ID_PK PRIMARY KEY (Employee_ID),
            CONSTRAINT C_Employee_Warehouse_ID_FK FOREIGN KEY (Warehouse_ID) REFERENCES WAREHOUSE(Warehouse_ID),
            CONSTRAINT C_Employee_Email_UNIQUE UNIQUE (Email),
            CONSTRAINT C_Employee_Email_CHECK CHECK (Email LIKE ''%_@__%.%__%'')
        )';

    EXCEPTION
        WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            dbms_output.put_line('Table WAREHOUSE_EMPLOYEE already exists.');
        ELSE
            dbms_output.put_line(SQLERRM);
        END IF;
            
    END;
-- create table UNIT
    BEGIN
        EXECUTE IMMEDIATE 'CREATE TABLE UNIT (
            Unit_ID VARCHAR2(50) DEFAULT Unit_ID_SEQ.NEXTVAL,
            Warehouse_ID VARCHAR2(50),
            Availability_Status VARCHAR2(2) DEFAULT ''A'',
            CONSTRAINT C_Unit_ID_PK PRIMARY KEY (Unit_ID),
            CONSTRAINT C_Unit_Availability_Status_CHECK CHECK (Availability_Status IN (''A'', ''NA'')),
            CONSTRAINT C_Unit_Warehouse_ID_FK FOREIGN KEY (Warehouse_ID) REFERENCES WAREHOUSE(Warehouse_ID)
        )';
    EXCEPTION
        WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            dbms_output.put_line('Table UNIT already exists.');
        ELSE
            dbms_output.put_line(SQLERRM);
        END IF;
            
    END;
-- create table LEASE
    BEGIN
        EXECUTE IMMEDIATE 'CREATE TABLE LEASE (
            Lease_ID VARCHAR2(50) DEFAULT Lease_ID_SEQ.NEXTVAL,
            Warehouse_ID VARCHAR2(50) NOT NULL,
            Customer_ID VARCHAR2(50) NOT NULL,
            Start_Date DATE DEFAULT SYSDATE,
            End_Date DATE DEFAULT ADD_MONTHS(SYSDATE, 1),
            Lease_Amount NUMBER(10, 2) NOT NULL,
            Due_Date DATE DEFAULT ADD_MONTHS(SYSDATE, 1),
            Payment_Status VARCHAR2(10) DEFAULT ''UNPAID'',
            Balance_Amount NUMBER(10, 2) NOT NULL,
            Units_leased NUMBER(5) NOT NULL,
            CONSTRAINT C_Lease_ID_PK PRIMARY KEY (Lease_ID),
            CONSTRAINT C_Lease_Warehouse_ID_FK FOREIGN KEY (Warehouse_ID) REFERENCES WAREHOUSE(Warehouse_ID),
            CONSTRAINT C_Lease_Customer_ID_FK FOREIGN KEY (Customer_ID) REFERENCES CUSTOMER(Customer_ID),
            CONSTRAINT C_Lease_Payment_Status_CHECK CHECK (Payment_Status IN (''PAID'', ''UNPAID'', ''PARTIAL''))
        )';
    EXCEPTION
        WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            dbms_output.put_line('Table LEASE already exists.');
        ELSE
            dbms_output.put_line(SQLERRM);
        END IF;
            
    END;
   -- create table LEASE_UNIT 
    BEGIN
        EXECUTE IMMEDIATE 'CREATE TABLE LEASE_UNIT (
            Lease_Unit_ID VARCHAR2(100) DEFAULT Lease_Unit_ID_SEQ.NEXTVAL,
            Unit_ID VARCHAR2(50) NOT NULL,
            Lease_ID VARCHAR2(50) NOT NULL,
            CONSTRAINT C_Lease_Unit_PK PRIMARY KEY (Lease_Unit_ID),
            CONSTRAINT C_Lease_Unit_Unit_ID_FK FOREIGN KEY (Unit_ID) REFERENCES UNIT(Unit_ID),
            CONSTRAINT C_Lease_Unit_Lease_ID_FK FOREIGN KEY (Lease_ID) REFERENCES LEASE(Lease_ID)
        )';
    EXCEPTION
        WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            dbms_output.put_line('Table LEASE_UNIT already exists.');
        ELSE
            dbms_output.put_line(SQLERRM);
        END IF;
            
    END;
      -- create table PAYMENT  
    BEGIN
        EXECUTE IMMEDIATE 'CREATE TABLE PAYMENT (
            Payment_ID VARCHAR2(50) DEFAULT Payment_ID_SEQ.NEXTVAL,
            Lease_ID VARCHAR2(50) NOT NULL,
            Transaction_Date TIMESTAMP DEFAULT SYSTIMESTAMP,
            Payment_Mode VARCHAR2(50) DEFAULT ''CARD'' NOT NULL,
            Transaction_Amount NUMBER(10, 2),
            CONSTRAINT C_Payment_ID_PK PRIMARY KEY (Payment_ID),
            CONSTRAINT C_Payment_Payment_Mode_CHECK CHECK (Payment_Mode IN (''CASH'', ''CHEQUE'', ''CARD'')),
            CONSTRAINT C_Payment_Lease_ID_FK FOREIGN KEY (Lease_ID) REFERENCES LEASE(Lease_ID)
        )';
    EXCEPTION
        WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            dbms_output.put_line('Table PAYMENT already exists.');
        ELSE
            dbms_output.put_line(SQLERRM);
        END IF;
            
    END;
       -- create table SERVICE_REQUEST   
    BEGIN
        EXECUTE IMMEDIATE 'CREATE TABLE SERVICE_REQUEST (
            Request_ID VARCHAR2(50) DEFAULT Service_Request_ID_SEQ.NEXTVAL,
            Lease_Unit_ID VARCHAR2(50) NOT NULL,
            Request_Desc VARCHAR2(250) NOT NULL,
            Request_Date DATE DEFAULT SYSDATE,
            Request_Status VARCHAR2(50) DEFAULT ''OPEN'',
            Customer_ID VARCHAR2(50) NOT NULL,
            CONSTRAINT C_Service_Request_ID_PK PRIMARY KEY (Request_ID),
            CONSTRAINT C_Service_Request_Customer_ID_FK FOREIGN KEY (Customer_ID) REFERENCES CUSTOMER(Customer_ID),
            CONSTRAINT C_Service_Request_Lease_Unit_ID_FK FOREIGN KEY (Lease_Unit_ID) REFERENCES LEASE_UNIT(Lease_Unit_ID),
            CONSTRAINT C_Service_Request_Request_Status_CHECK CHECK (Request_Status IN (''OPEN'', ''IN PROGRESS'', ''RESOLVED''))
        )';
    EXCEPTION
        WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            dbms_output.put_line('Table SERVICE_REQUEST already exists.');
        ELSE
            dbms_output.put_line(SQLERRM);
        END IF;
    END;

END;
/


BEGIN
    create_tables;
    COMMIT;
END;
/

-- BEGIN
--     FOR t IN (SELECT table_name FROM all_tables WHERE owner = 'WAREHOUSE_APP_ADMIN_USER') LOOP
--         EXECUTE IMMEDIATE 'GRANT ALL PRIVILEGES ON WAREHOUSE_APP_ADMIN_USER.' || t.table_name || ' TO WAREHOUSE_APP_ADMIN_USER';
--     END LOOP;
-- END;
-- /