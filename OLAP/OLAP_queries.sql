-- Top 5 Best-Selling Products by Quantity in 2024
SELECT
    dp.product_name,
    SUM(fs.quantity) AS total_quantity_sold
FROM
    Fact_Sales fs
JOIN
    Dim_Product dp ON fs.product_key = dp.product_key
JOIN
    Dim_Date dd ON fs.date_key = dd.date_key
WHERE
    dd.year = 2024
GROUP BY
    dp.product_name
ORDER BY
    total_quantity_sold DESC
LIMIT 5;

-- Total Quantity and Value of Recorded Inventory by Product Category
SELECT
    dc.category_name,
    SUM(fi.quantity_on_hand) AS total_quantity_in_stock,
    SUM(fi.inventory_value) AS total_stock_value
FROM
    Fact_Inventory fi
JOIN
    Dim_Product dp ON fi.product_key = dp.product_key
JOIN
    Product_Category_Bridge pcb ON dp.product_key = pcb.product_key
JOIN
    Dim_Category dc ON pcb.category_key = dc.category_key
GROUP BY
    dc.category_name
ORDER BY
    total_stock_value DESC;


-- Distinct Customers by Gender in 2024
SELECT
    dc.gender,
    COUNT(DISTINCT fs.customer_key) AS distinct_customers
FROM
    Fact_Sales fs
JOIN
    Dim_Customer dc ON fs.customer_key = dc.customer_key
JOIN
    Dim_Date dd ON fs.date_key = dd.date_key
WHERE
    dd.year = 2024
GROUP BY
    dc.gender
ORDER BY
    distinct_customers DESC;