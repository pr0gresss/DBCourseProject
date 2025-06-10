-- Drop all OLTP tables
DROP FOREIGN TABLE IF EXISTS Products_Inventory CASCADE;
DROP FOREIGN TABLE IF EXISTS Order_Item CASCADE;
DROP FOREIGN TABLE IF EXISTS Orders CASCADE;
DROP FOREIGN TABLE IF EXISTS Cart CASCADE;
DROP FOREIGN TABLE IF EXISTS Review CASCADE;
DROP FOREIGN TABLE IF EXISTS Product_Category CASCADE;
DROP FOREIGN TABLE IF EXISTS Product CASCADE;
DROP FOREIGN TABLE IF EXISTS Users CASCADE;
DROP FOREIGN TABLE IF EXISTS Payment CASCADE;
DROP FOREIGN TABLE IF EXISTS Brand CASCADE;
DROP FOREIGN TABLE IF EXISTS Category CASCADE;

CREATE TYPE order_status_enum AS ENUM (
    'pending', 
    'processing', 
    'shipped', 
    'delivered', 
    'cancelled',
    'refunded'
);

-- Connecting to OLTP database
CREATE EXTENSION IF NOT EXISTS postgres_fdw;

CREATE SERVER oltp
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host 'localhost', dbname 'OLTP', port '5432');

CREATE USER MAPPING FOR postgres
SERVER oltp
OPTIONS (user 'postgres', password '123');
-- Change creds if you have different ones

-- Loading OLTP tables as foreign tables in OLAP database
IMPORT FOREIGN SCHEMA public
LIMIT TO (users, payment, category, brand, product, product_category, products_inventory, orders, order_item, cart, review)
FROM SERVER oltp INTO public;

-- ETL SCRIPT
INSERT INTO Dim_Date (date_key, day_of_week, day_of_month, month, month_name, quater, year, is_weekend)
SELECT
    d::date AS date_key,
    EXTRACT(ISODOW FROM d)::int AS day_of_week,
    EXTRACT(DAY FROM d)::int AS day_of_month,
    EXTRACT(MONTH FROM d)::int AS month,
    TO_CHAR(d, 'Month') AS month_name,
    EXTRACT(QUARTER FROM d)::int AS quater,
    EXTRACT(YEAR FROM d)::int AS year,
    CASE WHEN EXTRACT(ISODOW FROM d) IN (6,7) THEN TRUE ELSE FALSE END AS is_weekend
FROM generate_series(
    CURRENT_DATE - INTERVAL '5 year',
    CURRENT_DATE + INTERVAL '1 year',
    '1 day'
) d
ON CONFLICT (date_key) DO NOTHING;

INSERT INTO Dim_Brand (brand_id, brand_name)
SELECT brand_id, brand_name
FROM brand
ON CONFLICT (brand_id) DO NOTHING;

INSERT INTO Dim_Category (category_id, category_name, description)
SELECT category_id, category_name, description
FROM category
ON CONFLICT (category_id) DO UPDATE SET
    category_name = EXCLUDED.category_name,
    description = EXCLUDED.description;

INSERT INTO Dim_Payment (payment_method_id, method_name)
SELECT payment_method_id, method_name
FROM payment
ON CONFLICT (payment_method_id) DO UPDATE SET
    method_name = EXCLUDED.method_name;

UPDATE Dim_Customer AS dc
SET
    expiry_date = CURRENT_DATE - INTERVAL '1 day',
    is_current = FALSE
FROM
    users AS u
WHERE
    dc.user_id = u.user_id AND
    dc.is_current = TRUE AND
    (
        dc.first_name IS DISTINCT FROM u.first_name OR
        dc.last_name IS DISTINCT FROM u.last_name OR
        dc.email IS DISTINCT FROM u.email OR
        dc.country IS DISTINCT FROM u.country OR
        dc.gender IS DISTINCT FROM u.gender
    );

WITH UserEarliestOrder AS (
    SELECT
        o.user_id,
        MIN(DATE(o.order_date)) AS first_order_date
    FROM orders o
    GROUP BY o.user_id
),
SourceCustomerData AS (
    SELECT
        ueo.user_id,
        u.first_name,
        u.last_name,
        u.email,
        u.country,
        u.gender,
        ueo.first_order_date
    FROM UserEarliestOrder ueo
    JOIN Users u ON ueo.user_id = u.user_id
)
INSERT INTO Dim_Customer (
    user_id,
    first_name,
    last_name,
    email,
    country,
    gender,
    effective_date,
    expiry_date,
    is_current
)
SELECT
    scd.user_id,
    scd.first_name,
    scd.last_name,
    scd.email,
    scd.country,
    scd.gender,
    scd.first_order_date AS effective_date,
    NULL AS expiry_date,
    TRUE AS is_current
FROM SourceCustomerData scd
LEFT JOIN Dim_Customer dc ON scd.user_id = dc.user_id AND dc.is_current = TRUE
WHERE dc.customer_key IS NULL;

WITH UserEarliestOrder AS (
    SELECT
        o.user_id,
        MIN(DATE(o.order_date)) AS first_order_date
    FROM orders o
    GROUP BY o.user_id
)
UPDATE Dim_Customer dc
SET effective_date = ueo.first_order_date
FROM UserEarliestOrder ueo
WHERE dc.user_id = ueo.user_id
  AND dc.is_current = TRUE
  AND DATE(dc.effective_date) > ueo.first_order_date;

INSERT INTO Dim_Product (
    product_id, product_name, brand_key, warranty_period,
    product_weight, price
)
SELECT
    p.product_id,
    p.product_name,
    db.brand_key,
    p.warranty_period,
    p.product_weight,
    p.price
FROM product p
JOIN brand b ON p.brand = b.brand_id
JOIN Dim_Brand db ON b.brand_id = db.brand_id
ON CONFLICT (product_id) DO UPDATE SET
    product_name = EXCLUDED.product_name,
    brand_key = EXCLUDED.brand_key,
    warranty_period = EXCLUDED.warranty_period,
    product_weight = EXCLUDED.product_weight,
    price = EXCLUDED.price;

INSERT INTO Product_Category_Bridge (product_key, category_key)
SELECT
    dp.product_key AS product_key,
    dc.category_key AS category_key
FROM product_category pc
JOIN Dim_Product dp ON dp.product_id = pc.product_id
JOIN Dim_Category dc ON dc.category_id = pc.category_id
ON CONFLICT (product_key, category_key) DO NOTHING;

INSERT INTO Fact_Inventory (
    product_key,
    date_key,
    quantity_on_hand,
    inventory_value
)
SELECT
    dp.product_key AS product_key,
    dd.date_key AS date_key,
    pi.quantity,
    (pi.quantity * dp.price) AS inventory_value
FROM (
    SELECT DISTINCT ON (product_id) *
    FROM products_inventory
    ORDER BY product_id, updated_at DESC
) pi
JOIN Dim_Product dp ON dp.product_id = pi.product_id
JOIN Dim_Date dd ON dd.date_key = DATE(pi.updated_at)
ON CONFLICT (product_key, date_key) DO UPDATE SET
    quantity_on_hand = EXCLUDED.quantity_on_hand,
    inventory_value = EXCLUDED.inventory_value;

INSERT INTO Fact_Sales (
    order_id,
    product_key,
    date_key,
    customer_key,
    payment_method_key,
    status,
    quantity,
    unit_price,
    total_amount
)
SELECT
    o.order_id,
    dp.product_key AS product_key,
    dd.date_key AS date_key,
    dc.customer_key AS customer_key,
    dpm.payment_method_key AS payment_method_key,
    o.order_status::TEXT,
    oi.quantity,
    dp.price,
    (oi.quantity * dp.price) AS total_amount
FROM order_item oi
JOIN orders o ON oi.order_id = o.order_id
JOIN Dim_Product dp ON dp.product_id = oi.product_id
JOIN Dim_Customer dc ON dc.user_id = o.user_id
    AND o.order_date >= dc.effective_date
    AND (o.order_date <= dc.expiry_date OR dc.expiry_date IS NULL)
JOIN Dim_Payment dpm ON dpm.payment_method_id = o.payment_method_id
JOIN Dim_Date dd ON dd.date_key = DATE(o.order_date)
ON CONFLICT (order_id, product_key) DO UPDATE SET
    status = EXCLUDED.status;