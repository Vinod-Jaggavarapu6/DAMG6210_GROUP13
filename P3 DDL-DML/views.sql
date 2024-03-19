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



SELECT * FROM Owners_Revenue_By_Location;

-- Payment Summary view 

CREATE OR REPLACE VIEW Payment_Summary_View AS
SELECT * 
FROM PAYMENT p
JOIN 
    LEASE l ON p.Lease_ID = l.Lease_ID
JOIN 
    CUSTOMER c ON c.Customer_ID = l.Customer_ID;


SELECT * FROM Payment_Summary_View;

-- Service Request View
CREATE OR REPLACE VIEW service_request_status_warehouse_view AS
SELECT r.Request_ID,w.Warehouse_ID,r.Request_Desc,r.Request_Date,r.Request_Status
FROM SERVICE_REQUEST r JOIN LEASE_UNIT l1 ON r.Lease_Unit_ID = l1.Lease_Unit_ID
JOIN LEASE l2 ON l1.Lease_ID = l2.Lease_ID
JOIN WAREHOUSE w ON l2.Warehouse_ID = w.Warehouse_ID;

select * from service_request_status_warehouse_view;

-- Customer Lease Details view

CREATE VIEW customer_lease_details AS
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
    customer_lease_details;