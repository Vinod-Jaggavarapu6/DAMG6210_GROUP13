-- view for warehouse owners and their revenue by location and total units available
CREATE OR REPLACE VIEW Owners_Revenue_By_Location AS
SELECT
    o.Owner_ID,
    o.Owner_Name,
    w.warehouse_name,
    lt.type_name,
    loc.City,
    loc.State,
    loc.Country,
    SUM(l.lease_amount) AS Total_Revenue,
    COUNT(u.Warehouse_ID) Total_Units,
    w.Available_Space
FROM
    LEASE l
JOIN 
    WAREHOUSE w ON l.Warehouse_ID = w.Warehouse_ID
JOIN
    UNIT u ON u.Warehouse_ID = w.Warehouse_ID
JOIN
    WAREHOUSE_OWNER o ON w.Owner_ID = o.Owner_ID
JOIN
    LOCATION loc ON w.Location_ID = loc.Location_ID
JOIN
    WAREHOUSE_TYPE lt ON w.Warehouse_Type_ID = lt.Warehouse_Type_ID
GROUP BY
    o.Owner_ID,
    o.Owner_Name,
    w.warehouse_name,
    lt.type_name,
    loc.City,
    loc.State,
    loc.Country,
    w.Available_Space
ORDER BY Total_Revenue DESC;


-- Payment Summary view 

CREATE OR REPLACE VIEW Payment_Summary_View AS
SELECT 
    p.payment_id,
    p.lease_id,
    l.customer_id,
    c.first_name||' '||c.last_name as customer_name,
    p.payment_mode,
    p.transaction_amount
FROM PAYMENT p
JOIN 
    LEASE l ON p.Lease_ID = l.Lease_ID
JOIN 
    CUSTOMER c ON c.Customer_ID = l.Customer_ID;

-- Customer Lease Details view
 
CREATE OR REPLACE VIEW customer_lease_details_view AS
    SELECT
        c.customer_id,
        c.first_name
        || ' '
        || c.last_name   AS customer_name,
        l.lease_id,
        w.warehouse_name AS warehouse_name,
        w.address        AS warehouse_address,
        l.start_date,
        l.end_date,
        l.lease_amount,
        l.payment_status,
        l.balance_amount
    FROM
             lease l
        INNER JOIN warehouse w ON l.warehouse_id = w.warehouse_id
        INNER JOIN customer  c ON l.customer_id = c.customer_id
    ORDER BY
        customer_id;
 
SELECT
    *
FROM
    customer_lease_details_view;

-- Service Request View
CREATE OR REPLACE VIEW service_request_status_warehouse_view AS
SELECT r.Request_ID,w.Warehouse_ID,r.Request_Desc,r.Request_Date,r.Request_Status
FROM SERVICE_REQUEST r JOIN LEASE_UNIT l1 ON r.Lease_Unit_ID = l1.Lease_Unit_ID
JOIN LEASE l2 ON l1.Lease_ID = l2.Lease_ID
JOIN WAREHOUSE w ON l2.Warehouse_ID = w.Warehouse_ID;
 
select * from service_request_status_warehouse_view;
    

-- Lease Units Available/Status View
 
CREATE OR REPLACE VIEW Lease_Units_Available AS
SELECT
    W.WAREHOUSE_ID,
    W.WAREHOUSE_NAME,
    WT.TYPE_NAME,
    WT.MONTHLY_RATE,
    U.UNIT_ID,
    U.AVAILABILITY_STATUS,
    L.LEASE_ID,
    L.START_DATE,
    L.END_DATE,
    C.CUSTOMER_ID,
    C.FIRST_NAME,
    C.LAST_NAME
 
FROM
    WAREHOUSE W
JOIN
    WAREHOUSE_TYPE WT ON W.WAREHOUSE_TYPE_ID = WT.WAREHOUSE_TYPE_ID
JOIN
    UNIT U ON W.WAREHOUSE_ID = U.WAREHOUSE_ID
LEFT JOIN
    LEASE_UNIT LU ON U.UNIT_ID = LU.UNIT_ID
LEFT JOIN
    LEASE L ON LU.LEASE_ID = L.LEASE_ID
LEFT JOIN
    CUSTOMER C ON L.CUSTOMER_ID = C.CUSTOMER_ID
WHERE
    L.END_DATE IS NULL OR L.END_DATE > SYSDATE;
    
    
SELECT * FROM Lease_Units_Available;

Warehouse Availability by Location View

CREATE OR REPLACE VIEW warehouse_availability_by_location AS
   SELECT DISTINCT
       loc.zip,
       w.warehouse_id,
       w.warehouse_name AS warehouse_name,
       w.address        AS warehouse_address,
       u.unit_id,
       CASE
           WHEN u.availability_status = 'NA' THEN
               'Available'
           ELSE
               'Occupied'
       END              AS occupancy_status
   FROM
            warehouse w
       INNER JOIN location loc ON w.location_id = loc.location_id
       INNER JOIN unit     u ON w.warehouse_id = u.warehouse_id;
SELECT
   *
FROM
   warehouse_availability_by_location;