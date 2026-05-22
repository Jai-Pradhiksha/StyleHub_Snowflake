-- Create and use our event database
CREATE OR REPLACE DATABASE STYLEHUB_DB;
USE DATABASE STYLEHUB_DB;
USE SCHEMA PUBLIC;

-- Define rules for how Snowflake should read different file types
CREATE OR REPLACE FILE FORMAT my_csv_format TYPE = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1;
CREATE OR REPLACE FILE FORMAT my_json_format TYPE = 'JSON';
CREATE OR REPLACE FILE FORMAT my_parquet_format TYPE = 'PARQUET';

-- Create structured table for Indian Users
CREATE OR REPLACE TABLE USERS (
    UserID INT,
    Name VARCHAR(100),
    Email VARCHAR(100),
    City VARCHAR(50)
);

-- Insert sample student profiles
INSERT INTO USERS (UserID, Name, Email, City) VALUES
(1, 'Aarav Sharma', 'aarav.sharma@clg.edu.in', 'Delhi'),
(2, 'Ananya Nair', 'ananya.nair@clg.edu.in', 'Chennai'),
(3, 'Rohan Das', 'rohan.das@clg.edu.in', 'Kolkata'),
(4, 'Priya Kumar', 'priya.kumar@clg.edu.in', 'Ahmedabad'),
(5, 'Srawan Rao ', 'srawan.rao@clg.edu.in', 'Mumbai');

-- Verify the ingestion
SELECT * FROM USERS;

-- Create table using VARIANT for flexible JSON schema
CREATE OR REPLACE TABLE PRODUCTS (
    ProductID INT,
    Details VARIANT
);

-- Insert complex, nested product data directly
INSERT INTO PRODUCTS (ProductID, Details)
SELECT 101, PARSE_JSON('{"name": "Over-sized Hoodie", "category": "Clothing", "price": 1499, "brand": "CampusWear"}')
UNION ALL
SELECT 102, PARSE_JSON('{"name": "Wireless Earbuds", "category": "Electronics", "price": 2199, "brand": "SonicIndia"}')
UNION ALL
SELECT 103, PARSE_JSON('{"name": "College Backpack", "category": "Accessories", "price": 1200, "brand": "PackMax"}');

-- Check how it looks inside Snowflake
SELECT * FROM PRODUCTS;

-- Transaction bridge table
CREATE OR REPLACE TABLE ORDERS (
    OrderID INT,
    UserID INT,
    ProductID INT,
    OrderDate DATE,
    Amount DECIMAL(10,2)
);

-- Insert active transactions linking users and products
INSERT INTO ORDERS (OrderID, UserID, ProductID, OrderDate, Amount) VALUES
(5001, 1, 101, '2026-05-15', 1499.00),
(5002, 2, 102, '2026-05-16', 2199.00),
(5003, 3, 101, '2026-05-16', 1499.00),
(5004, 4, 103, '2026-05-17', 1200.00),
(5005, 5, 102, '2026-05-18', 2199.00);

-- Join structured tables AND parse JSON at the exact same time
SELECT 
    o.OrderID,
    u.Name AS CustomerName,
    u.City,
    p.Details:name::STRING AS ProductName,
    p.Details:category::STRING AS Category,
    o.Amount
FROM ORDERS o
JOIN USERS u 
ON o.UserID = u.UserID
JOIN PRODUCTS p 
ON o.ProductID = p.ProductID;

INSERT INTO STYLEHUB_DB.PUBLIC.DAILY_SALES (SALE_DATA, SALE_TIME)
SELECT PARSE_JSON(column1), CURRENT_TIMESTAMP()
FROM VALUES
('{"sku": 1001, "qty": 3, "store_city": "Mumbai", "discount": 0.05}'),
('{"sku": 1002, "qty": 1, "store_city": "Mumbai", "discount": 0.15}'),
('{"sku": 1003, "qty": 2, "store_city": "Mumbai", "discount": 0.0}'),
('{"sku": 1001, "qty": 5, "store_city": "Bangalore", "discount": 0.1}'),
('{"sku": 1002, "qty": 2, "store_city": "Bangalore", "discount": 0.2}'),
('{"sku": 1003, "qty": 4, "store_city": "Bangalore", "discount": 0.05}'),
('{"sku": 1001, "qty": 2, "store_city": "Chennai", "discount": 0.0}'),
('{"sku": 1002, "qty": 3, "store_city": "Chennai", "discount": 0.1}'),
('{"sku": 1003, "qty": 1, "store_city": "Chennai", "discount": 0.15}'),
('{"sku": 1001, "qty": 4, "store_city": "Hyderabad", "discount": 0.1}'),
('{"sku": 1002, "qty": 1, "store_city": "Hyderabad", "discount": 0.0}'),
('{"sku": 1003, "qty": 3, "store_city": "Hyderabad", "discount": 0.1}'),
('{"sku": 1001, "qty": 1, "store_city": "Kolkata", "discount": 0.2}'),
('{"sku": 1002, "qty": 2, "store_city": "Kolkata", "discount": 0.05}'),
('{"sku": 1003, "qty": 2, "store_city": "Kolkata", "discount": 0.0}')
