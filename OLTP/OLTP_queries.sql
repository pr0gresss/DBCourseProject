-- Top 5 Best-Selling Products by Quantity in 2024
SELECT
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM
    Order_Item oi
JOIN
    Product p ON oi.product_id = p.product_id
JOIN
    Orders o ON oi.order_id = o.order_id
WHERE
    EXTRACT(YEAR FROM o.order_date) = 2024
GROUP BY
    p.product_name
ORDER BY
    total_quantity_sold DESC
LIMIT 5;

-- Total Quantity and Value of Recorded Inventory by Product Category
SELECT
    c.category_name,
    SUM(pi.quantity) AS total_quantity_recorded,
    SUM(pi.quantity * p.price) AS total_value_recorded
FROM
    Products_Inventory pi
JOIN
    Product p ON pi.product_id = p.product_id
JOIN
    Product_Category pc ON p.product_id = pc.product_id
JOIN
    Category c ON pc.category_id = c.category_id
GROUP BY
    c.category_name
ORDER BY
    total_value_recorded DESC;

-- Distinct Customers by Gender in 2024
SELECT
    u.gender,
    COUNT(DISTINCT o.user_id) AS distinct_customers
FROM
    Orders o
JOIN
    Users u ON o.user_id = u.user_id
WHERE
    EXTRACT(YEAR FROM o.order_date) = 2024
GROUP BY
    u.gender
ORDER BY
    distinct_customers DESC;