CREATE DATABASE ecommerce;
USE ecommerce;

-- Customers table
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    created_at DATE
);

-- Products table
CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2)
);

-- Orders table
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- OrderItems table
CREATE TABLE OrderItems (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Customers
INSERT INTO Customers (name, email, created_at) VALUES
('Alice', 'alice@example.com', '2024-01-15'),
('Bob', 'bob@example.com', '2024-02-20'),
('Charlie', 'charlie@example.com', '2024-03-05');

-- Products
INSERT INTO Products (name, category, price) VALUES
('Smartphone', 'Electronics', 699.99),
('Laptop', 'Electronics', 1199.00),
('Desk Chair', 'Furniture', 150.00);

-- Orders
INSERT INTO Orders (customer_id, order_date, total_amount) VALUES
(1, '2024-04-01', 849.99),
(2, '2024-04-15', 150.00);

-- OrderItems
INSERT INTO OrderItems (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 699.99),
(1, 3, 1, 150.00),
(2, 3, 1, 150.00);

SELECT name, price 
FROM Products;

SELECT * FROM Products 
WHERE category = 'Electronics';

SELECT * 
FROM Customers 
ORDER BY created_at DESC;

SELECT customer_id, SUM(total_amount) AS total_spent FROM Orders 
GROUP BY customer_id;

-- Get all orders with customer names (INNER JOIN)
SELECT o.order_id, o.order_date, c.name AS customer_name
FROM Orders o
INNER JOIN Customers c ON o.customer_id = c.customer_id;

-- LEFT JOIN: Show all customers even if they haven't placed any orders
SELECT c.name, o.order_id
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id;

-- Customers who placed orders worth more than $500
SELECT name 
FROM Customers 
WHERE customer_id IN (
    SELECT customer_id 
    FROM Orders 
    GROUP BY customer_id 
    HAVING SUM(total_amount) > 500
);

-- Products that were ordered at least once
SELECT name 
FROM Products 
WHERE product_id IN (
    SELECT DISTINCT product_id 
    FROM OrderItems
);

-- Total revenue generated from each product
SELECT p.name, SUM(oi.quantity * oi.price) AS total_revenue
FROM OrderItems oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY p.name;

-- Average order value
SELECT AVG(total_amount) AS average_order_value
FROM Orders;

-- Create a view for customer order summary
CREATE VIEW CustomerOrderSummary AS
SELECT c.customer_id, c.name, COUNT(o.order_id) AS total_orders, SUM(o.total_amount) AS total_spent
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

-- Use the view
SELECT * FROM CustomerOrderSummary WHERE total_spent > 500;

-- Add indexes to speed up queries on foreign keys
CREATE INDEX idx_orders_customer_id ON Orders(customer_id);
CREATE INDEX idx_orderitems_product_id ON OrderItems(product_id);























