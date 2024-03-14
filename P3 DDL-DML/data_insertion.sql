INSERT INTO CUSTOMER (First_Name, Last_Name, Customer_Address, Email, Phone) 
VALUES ('John', 'Doe', '123 Main St', 'john.doe@example.com', '1234567890');

INSERT INTO CUSTOMER (First_Name, Last_Name, Customer_Address, Email, Phone) 
VALUES ('Alice', 'Smith', '456 Elm St', 'alice.smith@example.com', '2345678901');

INSERT INTO CUSTOMER (First_Name, Last_Name, Customer_Address, Email, Phone) 
VALUES ('Bob', 'Johnson', '789 Oak St', 'bob.johnson@example.com', '3456789012');

INSERT INTO CUSTOMER (First_Name, Last_Name, Customer_Address, Email, Phone) 
VALUES ('Emily', 'Brown', '321 Maple St', 'emily.brown@example.com', '4567890123');

INSERT INTO CUSTOMER (First_Name, Last_Name, Customer_Address, Email, Phone) 
VALUES ('Michael', 'Wilson', '654 Pine St', 'michael.wilson@example.com', '5678901234');

INSERT INTO CUSTOMER (First_Name, Last_Name, Customer_Address, Email, Phone) 
VALUES ('Sophia', 'Martinez', '987 Cedar St', 'sophia.martinez@example.com', '6789012345');

INSERT INTO CUSTOMER (First_Name, Last_Name, Customer_Address, Email, Phone) 
VALUES ('William', 'Taylor', '741 Birch St', 'william.taylor@example.com', '7890123456');

INSERT INTO CUSTOMER (First_Name, Last_Name, Customer_Address, Email, Phone) 
VALUES ('Emma', 'Anderson', '852 Walnut St', 'emma.anderson@example.com', '8901234567');

INSERT INTO CUSTOMER (First_Name, Last_Name, Customer_Address, Email, Phone) 
VALUES ('James', 'Hernandez', '963 Sycamore St', 'james.hernandez@example.com', '9012345678');

INSERT INTO CUSTOMER (First_Name, Last_Name, Customer_Address, Email, Phone) 
VALUES ('Olivia', 'Garcia', '147 Cherry St', 'olivia.garcia@example.com', '0123456789');


INSERT INTO LOCATION (ZIP, City, State, Country) 
VALUES ('12345', 'New York', 'New York', 'USA');

INSERT INTO LOCATION (ZIP, City, State, Country) 
VALUES ('23456', 'Los Angeles', 'California', 'USA');

INSERT INTO LOCATION (ZIP, City, State, Country) 
VALUES ('34567', 'Chicago', 'Illinois', 'USA');

INSERT INTO LOCATION (ZIP, City, State, Country) 
VALUES ('45678', 'Houston', 'Texas', 'USA');

INSERT INTO LOCATION (ZIP, City, State, Country) 
VALUES ('56789', 'Phoenix', 'Arizona', 'USA');

INSERT INTO LOCATION (ZIP, City, State, Country) 
VALUES ('67890', 'Philadelphia', 'Pennsylvania', 'USA');

INSERT INTO LOCATION (ZIP, City, State, Country) 
VALUES ('78901', 'San Antonio', 'Texas', 'USA');

INSERT INTO LOCATION (ZIP, City, State, Country) 
VALUES ('89012', 'San Diego', 'California', 'USA');

INSERT INTO LOCATION (ZIP, City, State, Country) 
VALUES ('90123', 'Dallas', 'Texas', 'USA');

INSERT INTO LOCATION (ZIP, City, State, Country) 
VALUES ('01234', 'San Jose', 'California', 'USA');


INSERT INTO WAREHOUSE_TYPE (Type_Name, Monthly_Rate) 
VALUES ('Dry Storage', 1000.00);

INSERT INTO WAREHOUSE_TYPE (Type_Name, Monthly_Rate) 
VALUES ('Cold Storage', 1500.00);

INSERT INTO WAREHOUSE_TYPE (Type_Name, Monthly_Rate) 
VALUES ('Bulk Storage', 1200.00);

INSERT INTO WAREHOUSE_TYPE (Type_Name, Monthly_Rate) 
VALUES ('Distribution Center', 2000.00);

INSERT INTO WAREHOUSE_TYPE (Type_Name, Monthly_Rate) 
VALUES ('Fulfillment Center', 1800.00);

INSERT INTO WAREHOUSE_TYPE (Type_Name, Monthly_Rate) 
VALUES ('Specialized Storage', 2500.00);

INSERT INTO WAREHOUSE_OWNER (Owner_Name, Owner_Address, Email, Phone) 
VALUES ('John Doe', '123 Main St, Anytown, USA', 'john.doe@example.com', '1234567890');

INSERT INTO WAREHOUSE_OWNER (Owner_Name, Owner_Address, Email, Phone) 
VALUES ('Jane Smith', '456 Elm St, Othertown, USA', 'jane.smith@example.com', '9876543210');

INSERT INTO WAREHOUSE_OWNER (Owner_Name, Owner_Address, Email, Phone) 
VALUES ('David Johnson', '789 Oak St, Somewhere, USA', 'david.johnson@example.com', '1112223333');

INSERT INTO WAREHOUSE_OWNER (Owner_Name, Owner_Address, Email, Phone) 
VALUES ('Sarah Williams', '321 Pine St, Nowhere, USA', 'sarah.williams@example.com', '4445556666');

INSERT INTO WAREHOUSE_OWNER (Owner_Name, Owner_Address, Email, Phone) 
VALUES ('Michael Brown', '654 Maple St, Anytown, USA', 'michael.brown@example.com', '7778889999');

INSERT INTO WAREHOUSE_OWNER (Owner_Name, Owner_Address, Email, Phone) 
VALUES ('Emily Wilson', '987 Cedar St, Othertown, USA', 'emily.wilson@example.com', '1212121212');

INSERT INTO WAREHOUSE_OWNER (Owner_Name, Owner_Address, Email, Phone) 
VALUES ('Christopher Lee', '159 Birch St, Somewhere, USA', 'christopher.lee@example.com', '3434343434');


INSERT INTO WAREHOUSE (Warehouse_Name, Address, Available_Space, Warehouse_Type_ID, Location_ID, Owner_ID, Location_LAT, Location_LONG) 
VALUES ('WAREHOUSE A', '123 Main St, Anytown, USA', 10, 1, 1, 1, 40.7128, -74.0060);

INSERT INTO WAREHOUSE (Warehouse_Name, Address, Available_Space, Warehouse_Type_ID, Location_ID, Owner_ID, Location_LAT, Location_LONG) 
VALUES ('WAREHOUSE B', '456 Elm St, Othertown, USA', 5, 2, 2, 2, 34.0522, -118.2437);

INSERT INTO WAREHOUSE (Warehouse_Name, Address, Available_Space, Warehouse_Type_ID, Location_ID, Owner_ID, Location_LAT, Location_LONG) 
VALUES ('WAREHOUSE C', '789 Oak St, Somewhere, USA', 2, 3, 3, 3, 29.7604, -95.3698);

INSERT INTO WAREHOUSE (Warehouse_Name, Address, Available_Space, Warehouse_Type_ID, Location_ID, Owner_ID, Location_LAT, Location_LONG) 
VALUES ('WAREHOUSE D', '321 Pine St, Nowhere, USA', 25, 4, 4, 4, 41.8781, -87.6298);

INSERT INTO WAREHOUSE (Warehouse_Name, Address, Available_Space, Warehouse_Type_ID, Location_ID, Owner_ID, Location_LAT, Location_LONG) 
VALUES ('WAREHOUSE E', '654 Maple St, Anytown, USA', 3, 5, 5, 5, 37.7749, -122.4194);

INSERT INTO WAREHOUSE (Warehouse_Name, Address, Available_Space, Warehouse_Type_ID, Location_ID, Owner_ID, Location_LAT, Location_LONG) 
VALUES ('WAREHOUSE F', '987 Cedar St, Othertown, USA', 35, 6, 6, 6, 33.4484, -112.0740);

INSERT INTO WAREHOUSE (Warehouse_Name, Address, Available_Space, Warehouse_Type_ID, Location_ID, Owner_ID, Location_LAT, Location_LONG) 
VALUES ('WAREHOUSE G', '159 Birch St, Somewhere, USA', 4, 1, 7, 1, 32.7157, -117.1611);

INSERT INTO WAREHOUSE (Warehouse_Name, Address, Available_Space, Warehouse_Type_ID, Location_ID, Owner_ID, Location_LAT, Location_LONG) 
VALUES ('WAREHOUSE H', '111 Oak St, Nowhere, USA', 4, 2, 8, 2, 34.0522, -118.2437);

INSERT INTO WAREHOUSE (Warehouse_Name, Address, Available_Space, Warehouse_Type_ID, Location_ID, Owner_ID, Location_LAT, Location_LONG) 
VALUES ('WAREHOUSE I', '222 Elm St, Anytown, USA', 5, 3, 9, 3, 40.7128, -74.0060);

INSERT INTO WAREHOUSE (Warehouse_Name, Address, Available_Space, Warehouse_Type_ID, Location_ID, Owner_ID, Location_LAT, Location_LONG) 
VALUES ('WAREHOUSE J', '333 Pine St, Othertown, USA', 5, 4, 10, 4, 34.0522, -118.2437);

INSERT INTO WAREHOUSE (Warehouse_Name, Address, Available_Space, Warehouse_Type_ID, Location_ID, Owner_ID, Location_LAT, Location_LONG) 
VALUES ('WAREHOUSE K', '444 Oak St, Somewhere, USA', 6, 5, 1, 5, 29.7604, -95.3698);

INSERT INTO WAREHOUSE (Warehouse_Name, Address, Available_Space, Warehouse_Type_ID, Location_ID, Owner_ID, Location_LAT, Location_LONG) 
VALUES ('WAREHOUSE L', '555 Cedar St, Nowhere, USA', 6, 6, 2, 6, 41.8781, -87.6298);

INSERT INTO WAREHOUSE (Warehouse_Name, Address, Available_Space, Warehouse_Type_ID, Location_ID, Owner_ID, Location_LAT, Location_LONG) 
VALUES ('WAREHOUSE M', '666 Maple St, Anytown, USA', 10, 1, 3, 7, 37.7749, -122.4194);

INSERT INTO WAREHOUSE (Warehouse_Name, Address, Available_Space, Warehouse_Type_ID, Location_ID, Owner_ID, Location_LAT, Location_LONG) 
VALUES ('WAREHOUSE N', '777 Birch St, Othertown, USA', 7, 2, 4, 1, 33.4484, -112.0740);

INSERT INTO WAREHOUSE (Warehouse_Name, Address, Available_Space, Warehouse_Type_ID, Location_ID, Owner_ID, Location_LAT, Location_LONG) 
VALUES ('WAREHOUSE O', '888 Pine St, Somewhere, USA', 8, 3, 5, 7, 37.7749, -122.4194);


-- Warehouse A Employees
INSERT INTO WAREHOUSE_EMPLOYEE (Warehouse_ID, Employee_Name, Address, Email, Phone, Role, Salary) 
VALUES ('1', 'John Doe', '123 Main St, Anytown, USA', 'john.doe@example.com', '1234567890', 'Manager', 50000.00);

INSERT INTO WAREHOUSE_EMPLOYEE (Warehouse_ID, Employee_Name, Address, Email, Phone, Role, Salary) 
VALUES ('1', 'Jane Smith', '123 Main St, Anytown, USA', 'jane.smith@example.com', '1234567891', 'Assistant Manager', 40000.00);

-- Warehouse B Employees
INSERT INTO WAREHOUSE_EMPLOYEE (Warehouse_ID, Employee_Name, Address, Email, Phone, Role, Salary) 
VALUES ('2', 'Mark Johnson', '456 Elm St, Othertown, USA', 'mark.johnson@example.com', '1234567892', 'Manager', 48000.00);

INSERT INTO WAREHOUSE_EMPLOYEE (Warehouse_ID, Employee_Name, Address, Email, Phone, Role, Salary) 
VALUES ('2', 'Emily Brown', '456 Elm St, Othertown, USA', 'emily.brown@example.com', '1234567893', 'Assistant Manager', 38000.00);

-- Warehouse C Employees
INSERT INTO WAREHOUSE_EMPLOYEE (Warehouse_ID, Employee_Name, Address, Email, Phone, Role, Salary) 
VALUES ('3', 'Michael Williams', '789 Oak St, Somewhere, USA', 'michael.williams@example.com', '1234567894', 'Manager', 52000.00);

INSERT INTO WAREHOUSE_EMPLOYEE (Warehouse_ID, Employee_Name, Address, Email, Phone, Role, Salary) 
VALUES ('3', 'Emma Taylor', '789 Oak St, Somewhere, USA', 'emma.taylor@example.com', '1234567895', 'Assistant Manager', 42000.00);

-- Warehouse D Employees
INSERT INTO WAREHOUSE_EMPLOYEE (Warehouse_ID, Employee_Name, Address, Email, Phone, Role, Salary) 
VALUES ('4', 'David Garcia', '321 Pine St, Anotherplace, USA', 'david.garcia@example.com', '1234567896', 'Manager', 53000.00);

INSERT INTO WAREHOUSE_EMPLOYEE (Warehouse_ID, Employee_Name, Address, Email, Phone, Role, Salary) 
VALUES ('4', 'Olivia Martinez', '321 Pine St, Anotherplace, USA', 'olivia.martinez@example.com', '1234567897', 'Assistant Manager', 41000.00);

-- Warehouse E Employees
INSERT INTO WAREHOUSE_EMPLOYEE (Warehouse_ID, Employee_Name, Address, Email, Phone, Role, Salary) 
VALUES ('5', 'James Rodriguez', '654 Maple St, Elsewhere, USA', 'james.rodriguez@example.com', '1234567898', 'Manager', 54000.00);

INSERT INTO WAREHOUSE_EMPLOYEE (Warehouse_ID, Employee_Name, Address, Email, Phone, Role, Salary) 
VALUES ('5', 'Sophia Hernandez', '654 Maple St, Elsewhere, USA', 'sophia.hernandez@example.com', '1234567899', 'Assistant Manager', 43000.00);

-- Warehouse F Employees
INSERT INTO WAREHOUSE_EMPLOYEE (Warehouse_ID, Employee_Name, Address, Email, Phone, Role, Salary) 
VALUES ('6', 'Logan Smith', '987 Cedar St, Nowhere, USA', 'logan.smith@example.com', '1234567800', 'Manager', 55000.00);

INSERT INTO WAREHOUSE_EMPLOYEE (Warehouse_ID, Employee_Name, Address, Email, Phone, Role, Salary) 
VALUES ('6', 'Ava Johnson', '987 Cedar St, Nowhere, USA', 'ava.johnson@example.com', '1234567801', 'Assistant Manager', 44000.00);

-- Warehouse G Employees
INSERT INTO WAREHOUSE_EMPLOYEE (Warehouse_ID, Employee_Name, Address, Email, Phone, Role, Salary) 
VALUES ('7', 'Noah Brown', '753 Birch St, Anywhere, USA', 'noah.brown@example.com', '1234567802', 'Manager', 56000.00);

INSERT INTO WAREHOUSE_EMPLOYEE (Warehouse_ID, Employee_Name, Address, Email, Phone, Role, Salary) 
VALUES ('7', 'Isabella Taylor', '753 Birch St, Anywhere, USA', 'isabella.taylor@example.com', '1234567803', 'Assistant Manager', 45000.00);

-- Warehouse H Employees
INSERT INTO WAREHOUSE_EMPLOYEE (Warehouse_ID, Employee_Name, Address, Email, Phone, Role, Salary) 
VALUES ('8', 'William Martinez', '852 Oak St, Somewhere, USA', 'william.martinez@example.com', '1234567804', 'Manager', 57000.00);

INSERT INTO WAREHOUSE_EMPLOYEE (Warehouse_ID, Employee_Name, Address, Email, Phone, Role, Salary) 
VALUES ('8', 'Mia Nguyen', '852 Oak St, Somewhere, USA', 'mia.nguyen@example.com', '1234567805', 'Assistant Manager', 46000.00);

-- Warehouse I Employees
INSERT INTO WAREHOUSE_EMPLOYEE (Warehouse_ID, Employee_Name, Address, Email, Phone, Role, Salary) 
VALUES ('9', 'Ethan Anderson', '369 Elm St, Everywhere, USA', 'ethan.anderson@example.com', '1234567806', 'Manager', 58000.00);

INSERT INTO WAREHOUSE_EMPLOYEE (Warehouse_ID, Employee_Name, Address, Email, Phone, Role, Salary) 
VALUES ('9', 'Amelia Thomas', '369 Elm St, Everywhere, USA', 'amelia.thomas@example.com', '1234567807', 'Assistant Manager', 47000.00);

-- Warehouse J Employees
INSERT INTO WAREHOUSE_EMPLOYEE (Warehouse_ID, Employee_Name, Address, Email, Phone, Role, Salary) 
VALUES ('10', 'Oliver Wilson', '147 Walnut St, Nowhen, USA', 'oliver.wilson@example.com', '1234567808', 'Manager', 59000.00);

INSERT INTO WAREHOUSE_EMPLOYEE (Warehouse_ID, Employee_Name, Address, Email, Phone, Role, Salary) 
VALUES ('10', 'Charlotte White', '147 Walnut St, Nowhen, USA', 'charlotte.white@example.com', '1234567809', 'Assistant Manager', 48000.00);

-- Lease for Warehouse A, Customer John Doe
INSERT INTO LEASE (Warehouse_ID, Customer_ID, Start_Date, End_Date, Lease_Amount, Due_Date, Payment_Status, Balance_Amount, Units_leased)
VALUES ('1', '1', TO_DATE('2024-03-14', 'YYYY-MM-DD'), TO_DATE('2024-06-14', 'YYYY-MM-DD'), 3000.00, TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'UNPAID', 3000.00, 3);

-- Lease for Warehouse B, Customer Alice Smith
INSERT INTO LEASE (Warehouse_ID, Customer_ID, Start_Date, End_Date, Lease_Amount, Due_Date, Payment_Status, Balance_Amount, Units_leased)
VALUES ('2', '2', TO_DATE('2024-03-14', 'YYYY-MM-DD'), TO_DATE('2024-06-14', 'YYYY-MM-DD'), 4500.00, TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'UNPAID', 4500.00, 2);

-- Lease for Warehouse C, Customer Bob Johnson
INSERT INTO LEASE (Warehouse_ID, Customer_ID, Start_Date, End_Date, Lease_Amount, Due_Date, Payment_Status, Balance_Amount, Units_leased)
VALUES ('3', '3', TO_DATE('2024-03-14', 'YYYY-MM-DD'), TO_DATE('2024-06-14', 'YYYY-MM-DD'), 2400.00, TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'UNPAID', 2400.00, 1);

-- Lease for Warehouse D, Customer Emily Brown
INSERT INTO LEASE (Warehouse_ID, Customer_ID, Start_Date, End_Date, Lease_Amount, Due_Date, Payment_Status, Balance_Amount, Units_leased)
VALUES ('4', '4', TO_DATE('2024-03-14', 'YYYY-MM-DD'), TO_DATE('2024-06-14', 'YYYY-MM-DD'), 6250.00, TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'UNPAID', 6250.00, 5);

-- Lease for Warehouse E, Customer Michael Wilson
INSERT INTO LEASE (Warehouse_ID, Customer_ID, Start_Date, End_Date, Lease_Amount, Due_Date, Payment_Status, Balance_Amount, Units_leased)
VALUES ('5', '5', TO_DATE('2024-03-14', 'YYYY-MM-DD'), TO_DATE('2024-06-14', 'YYYY-MM-DD'), 5400.00, TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'UNPAID', 5400.00, 1);

-- Lease for Warehouse F, Customer Sophia Martinez
INSERT INTO LEASE (Warehouse_ID, Customer_ID, Start_Date, End_Date, Lease_Amount, Due_Date, Payment_Status, Balance_Amount, Units_leased)
VALUES ('6', '6', TO_DATE('2024-03-14', 'YYYY-MM-DD'), TO_DATE('2024-06-14', 'YYYY-MM-DD'), 6300.00, TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'UNPAID', 6300.00, 6);

-- Lease for Warehouse G, Customer William Taylor
INSERT INTO LEASE (Warehouse_ID, Customer_ID, Start_Date, End_Date, Lease_Amount, Due_Date, Payment_Status, Balance_Amount, Units_leased)
VALUES ('7', '7', TO_DATE('2024-03-14', 'YYYY-MM-DD'), TO_DATE('2024-06-14', 'YYYY-MM-DD'), 2800.00, TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'UNPAID', 2800.00, 2);

-- Lease for Warehouse H, Customer Emma Anderson
INSERT INTO LEASE (Warehouse_ID, Customer_ID, Start_Date, End_Date, Lease_Amount, Due_Date, Payment_Status, Balance_Amount, Units_leased)
VALUES ('8', '8', TO_DATE('2024-03-14', 'YYYY-MM-DD'), TO_DATE('2024-06-14', 'YYYY-MM-DD'), 3000.00, TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'UNPAID', 3000.00, 3);

-- Lease for Warehouse I, Customer James Hernandez
INSERT INTO LEASE (Warehouse_ID, Customer_ID, Start_Date, End_Date, Lease_Amount, Due_Date, Payment_Status, Balance_Amount, Units_leased)
VALUES ('9', '9', TO_DATE('2024-03-14', 'YYYY-MM-DD'), TO_DATE('2024-06-14', 'YYYY-MM-DD'), 6000.00, TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'UNPAID', 6000.00, 4);

-- Lease for Warehouse J, Customer Olivia Garcia
INSERT INTO LEASE (Warehouse_ID, Customer_ID, Start_Date, End_Date, Lease_Amount, Due_Date, Payment_Status, Balance_Amount, Units_leased)
VALUES ('10', '10', TO_DATE('2024-03-14', 'YYYY-MM-DD'), TO_DATE('2024-06-14', 'YYYY-MM-DD'), 4800.00, TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'UNPAID', 4800.00, 3);

INSERT INTO PAYMENT (Lease_ID, Transaction_Date, Payment_Mode, Transaction_Amount)
SELECT
    l.Lease_ID,
    SYSDATE, -- Assuming current date as the transaction date
    'CARD',
    l.Balance_Amount -- Payment amount equals the balance amount
FROM
    LEASE l
WHERE
    l.Payment_Status IN ('UNPAID', 'PARTIAL') AND ROWNUM <= 5;
    

INSERT INTO SERVICE_REQUEST (Lease_Unit_ID, Request_Desc, Request_Date, Request_Status, Customer_ID)
SELECT
    lu.Lease_Unit_ID,
    'Request description for Lease Unit ' || lu.Lease_Unit_ID,
    SYSDATE, -- Assuming current date as the request date
    'OPEN', -- Initial request status
    c.Customer_ID
FROM
    LEASE_UNIT lu
INNER JOIN LEASE l ON lu.Lease_ID = l.Lease_ID
INNER JOIN CUSTOMER c ON l.Customer_ID = c.Customer_ID
WHERE
    ROWNUM <= 5; -- Inserting requests for the first 5 lease units

