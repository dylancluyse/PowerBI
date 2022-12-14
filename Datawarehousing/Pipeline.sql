SET SQL_SAFE_UPDATES = 0;

-- Empty and recreate DimDate
DELETE FROM DimDATE;

CALL sp_DimDate ();

-- Empty and recreate DimProduct

DELETE FROM DimProduct;

INSERT INTO DimProduct
SELECT p.ProductID ProductKey, p.ProductName, c.CategoryName, p.QuantityPerUnit, p.UnitPrice
FROM northwind.products p JOIN northwind.categories c ON p.CategoryID = c.CategoryID;



-- What is the minimum OrderDate in Orders? This is the StartDate for DimCustomer
SELECT @start := MIN(OrderDATE) FROM northwind.orders;

INSERT INTO DimCustomer(CustomerID, CompanyName, City, Region, Country, Start)
SELECT CustomerID, CompanyName, City, Region, Country, @Start FROM northwind.Customers WHERE CustomerID NOT IN (SELECT CustomerID FROM DimCustomer);

-- Implementing SCD
-- Temporary table that holds all customers that were changed

CREATE TEMPORARY TABLE temp_tbl 
SELECT c.customerID, c.companyName, dc.city As OldCity, c.city As NewCity, dc.region As OldRegion, c.region As NewRegion, dc.country As OldCountry, c.country As NewCountry
FROM DimCustomer dc JOIN northwind.customers c ON dc.customerID = c.customerID 
WHERE ((c.city != dc.city) OR (c.region != dc.region) OR (c.country != dc.country)) AND dc.END IS NULL;


-- The end date of the updated customers is updated
UPDATE DimCustomer SET End = DATE_ADD(CURDATE(), INTERVAL -1 DAY)
WHERE CustomerID IN (SELECT CustomerID FROM temp_tbl);

-- The changed customers are inserted in DimCustomer
INSERT INTO DimCustomer(CustomerID, CompanyName, City, Region, Country, Start)
SELECT CustomerID, companyName, NewCity, NewRegion, NewCountry, CURDATE()
FROM temp_tbl;

DROP TABLE temp_tbl;


INSERT INTO FactSales(OrderLine, ProductKey, CustomerKey, 
OrderDateKey, OrderUnitPrice, OrderQuantity, OrderDiscount)
SELECT od.OrderID, od.productID, dc.CustomerKey, CONVERT(DATE_FORMAT(o.OrderDate,'%Y%m%d'), SIGNED), od.UnitPrice, od.Quantity, od.Discount
from Northwind.Order_Details od JOIN Northwind.Orders o ON od.OrderID = o.OrderID
join DimCustomer dc on o.CustomerID = dc.CustomerID
WHERE 
/* Slowly Changing Dimension dimCustomer */
o.OrderDate >= dc.start and (dc.END is null or o.orderdate <= dc.END) 
AND
/* only add new lines + make sure it runs from an empty FactSales table */
o.OrderID > (SELECT IFNULL(MAX(OrderLine),0) from FactSales)




























































