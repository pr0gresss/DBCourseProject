-- Drop OLAP tables
DROP TABLE IF EXISTS Product_Category_Bridge;
DROP TABLE IF EXISTS Fact_Sales;
DROP TABLE IF EXISTS Fact_Inventory;
DROP TABLE IF EXISTS Dim_Product;
DROP TABLE IF EXISTS Dim_Brand;
DROP TABLE IF EXISTS Dim_Category;
DROP TABLE IF EXISTS Dim_Customer;
DROP TABLE IF EXISTS Dim_Payment;
DROP TABLE IF EXISTS Dim_Date;

-- Create OLAP tables
CREATE TABLE Dim_Brand (
    brand_key SERIAL PRIMARY KEY,
    brand_id INT UNIQUE,
    brand_name VARCHAR(40)
);

CREATE TABLE Dim_Category (
    category_key SERIAL PRIMARY KEY,
    category_id INT UNIQUE,
    category_name VARCHAR(30),
    description TEXT
);

CREATE TABLE Dim_Payment (
    payment_method_key SERIAL PRIMARY KEY,
    payment_method_id INT UNIQUE,
    method_name VARCHAR(30)
);

CREATE TABLE Dim_Date (
    date_key date PRIMARY KEY,
    day_of_week INT,
    day_of_month INT,
    month INT,
    month_name VARCHAR(20),
    quater INT,
    year INT,
    is_weekend BOOLEAN
);

CREATE TABLE Dim_Customer (
    customer_key SERIAL PRIMARY KEY,
    user_id INT,
    first_name VARCHAR(30),
    last_name VARCHAR(30),
    email VARCHAR(50),
    country VARCHAR(50),
    gender VARCHAR(20),
    effective_date DATE,
    expiry_date DATE,
    is_current BOOLEAN
);

CREATE TABLE Dim_Product (
    product_key SERIAL PRIMARY KEY,
    product_id INT UNIQUE,
    product_name VARCHAR(70),
    brand_key INT REFERENCES Dim_Brand(brand_key),
    warranty_period TEXT,
    product_weight FLOAT,
    price FLOAT
);

CREATE TABLE Product_Category_Bridge (
    product_key INT REFERENCES Dim_Product(product_key),
    category_key INT REFERENCES Dim_Category(category_key),
    PRIMARY KEY (product_key, category_key)
);

CREATE TABLE Fact_Inventory (
    inventory_key SERIAL PRIMARY KEY,
    product_key INT REFERENCES Dim_Product(product_key),
    date_key date REFERENCES Dim_Date(date_key),
    quantity_on_hand INT,
    inventory_value FLOAT,
	UNIQUE(product_key, date_key)
);

CREATE TABLE Fact_Sales (
    sales_key SERIAL PRIMARY KEY,
	order_id INT NOT NULL,
    product_key INT REFERENCES Dim_Product(product_key),
    date_key date REFERENCES Dim_Date(date_key),
    customer_key INT REFERENCES Dim_Customer(customer_key),
    payment_method_key INT REFERENCES Dim_Payment(payment_method_key),
    status TEXT,
    quantity INT,
    unit_price FLOAT,
    total_amount FLOAT,
	UNIQUE (order_id, product_key)
);
