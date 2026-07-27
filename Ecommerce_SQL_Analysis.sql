CREATE DATABASE ecommerce_db;

USE ecommerce_db;

--Customers Tablee

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    country VARCHAR(50)
);

--Products table

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

--orders table

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    order_date DATE,
    quantity INT,
    revenue DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO customers VALUES
(1, 'Amit Sharma', 'Nagpur', 'India'),
(2, 'Priya Patil', 'Pune', 'India'),
(3, 'Rahul Verma', 'Mumbai', 'India'),
(4, 'Sneha Joshi', 'Delhi', 'India'),
(5, 'Neha Singh', 'Bangalore', 'India');

INSERT INTO products VALUES
(101, 'Laptop', 'Electronics', 55000),
(102, 'Mobile Phone', 'Electronics', 25000),
(103, 'Headphones', 'Electronics', 2000),
(104, 'Office Chair', 'Furniture', 8000),
(105, 'Notebook', 'Stationery', 100);

INSERT INTO orders VALUES
(1001, 1, 101, '2026-07-01', 1, 55000),
(1002, 2, 102, '2026-07-02', 2, 50000),
(1003, 3, 103, '2026-07-03', 3, 6000),
(1004, 1, 104, '2026-07-05', 1, 8000),
(1005, 4, 105, '2026-07-06', 10, 1000),
(1006, 5, 101, '2026-07-08', 1, 55000),
(1007, 2, 103, '2026-07-10', 2, 4000),
(1008, 3, 102, '2026-07-12', 1, 25000);

SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;

--SELECT(SEPECIFIC COLUMNS)

SELECT customer_id, customer_name, city
FROM customers;

--WHERE CLAUSE

SELECT *
FROM customers
WHERE city = 'Nagpur';

--ORDER BY

SELECT *
FROM customers
ORDER BY customer_name ASC;

--GROUP BY

SELECT 
    p.category,
    SUM(o.revenue) AS total_revenue
FROM orders o
JOIN products p 
    ON o.product_id = p.product_id
GROUP BY p.category;

--SUM()

SELECT SUM(revenue) AS total_revenue
FROM orders;

--AVG()

SELECT AVG(revenue) AS average_revenue
FROM orders;

--INNER JOIN()

SELECT
    c.customer_name,
    o.order_id,
    o.order_date,
    o.revenue
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id;

--JOIN 3 TABLES()

    SELECT
    c.customer_name,
    p.product_name,
    p.category,
    o.quantity,
    o.revenue
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id
INNER JOIN products p
    ON o.product_id = p.product_id;

--LEFT JOIN()

    SELECT
    c.customer_name,
    o.order_id,
    o.revenue
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id;

--RIGHT JOIN()    
    SELECT
    c.customer_name,
    o.order_id,
    o.revenue
FROM customers c
RIGHT JOIN orders o
    ON c.customer_id = o.customer_id;
  
  --SUBQUERY()
    SELECT
    order_id,
    customer_id,
    revenue
FROM orders
WHERE revenue > (
    SELECT AVG(revenue)
    FROM orders
);

--NULL VALUES()

SELECT *
FROM orders
WHERE customer_id IS NULL
   OR product_id IS NULL
   OR order_date IS NULL
   OR quantity IS NULL
   OR revenue IS NULL;
   
   --NULL VALUE HANDLE WITH COALESCE
   SELECT
    order_id,
    COALESCE(revenue, 0) AS revenue
FROM orders;

--VIEW QUERY

CREATE VIEW ecommerce_sales_analysis AS
SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    p.product_name,
    p.category,
    o.order_id,
    o.order_date,
    o.quantity,
    o.revenue
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id
INNER JOIN products p
    ON o.product_id = p.product_id;

SELECT *
FROM ecommerce_sales_analysis;

--VIEW (CATEGORY WISE)
SELECT
    category,
    SUM(revenue) AS total_revenue
FROM ecommerce_sales_analysis
GROUP BY category
ORDER BY total_revenue DESC;

--Index & Query Optimisation
--Existing indexes()

SHOW INDEX FROM orders;

--CUSTOMER ID WITH INDEX

CREATE INDEX idx_orders_customer_id
ON orders(customer_id);

--PRODUCT ID WITH INDEX

CREATE INDEX idx_orders_product_id
ON orders(product_id);

SHOW INDEX FROM orders;

--QUERY OPTIMISATION

EXPLAIN
SELECT
    c.customer_name,
    o.order_id,
    o.revenue
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id;
