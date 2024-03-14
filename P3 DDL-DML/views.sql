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