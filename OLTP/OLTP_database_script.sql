-- Drop OLTP tables
DROP TABLE IF EXISTS Products_Inventory CASCADE;
DROP TABLE IF EXISTS Order_Item CASCADE;
DROP TABLE IF EXISTS Orders CASCADE;
DROP TABLE IF EXISTS Cart CASCADE;
DROP TABLE IF EXISTS Review CASCADE;
DROP TABLE IF EXISTS Product CASCADE;
DROP TABLE IF EXISTS Users CASCADE;
DROP TABLE IF EXISTS Payment CASCADE;
DROP TABLE IF EXISTS Brand CASCADE;
DROP TABLE IF EXISTS Product_Category CASCADE;
DROP TABLE IF EXISTS Category CASCADE;
DROP TYPE IF EXISTS order_status_enum;

-- Create OLTP tables
CREATE TYPE order_status_enum AS ENUM (
    'pending', 
    'processing', 
    'shipped', 
    'delivered', 
    'cancelled',
    'refunded'
);

CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    phone VARCHAR(20),
    country VARCHAR(50),
    gender VARCHAR(20)
);

CREATE TABLE Payment (
    payment_method_id SERIAL PRIMARY KEY,
    method_name VARCHAR(30) NOT NULL
);

CREATE TABLE Category (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(30) NOT NULL,
    description TEXT
);

CREATE TABLE Brand(
	brand_id SERIAL PRIMARY KEY,
	brand_name VARCHAR(40)
);

CREATE TABLE Product (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(70) NOT NULL,
    brand INT NOT NULL REFERENCES Brand(brand_id),
    warranty_period TEXT,
    product_weight FLOAT,
    price FLOAT NOT NULL,
    product_description TEXT
);

CREATE TABLE Product_Category (
    product_id INT PRIMARY KEY REFERENCES Product(product_id),
    category_id INT NOT NULL REFERENCES Category(category_id)
);

CREATE TABLE Products_Inventory (
    update_id SERIAL PRIMARY KEY,
    product_id INT NOT NULL REFERENCES Product(product_id),
    quantity INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
);

CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    payment_method_id INT REFERENCES Payment(payment_method_id),
    order_status order_status_enum NOT NULL DEFAULT 'pending',
    user_id INT NOT NULL REFERENCES Users(user_id),
    total_amount INT NOT NULL,
    delivery_address TEXT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Order_Item (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES Orders(order_id),
    product_id INT NOT NULL REFERENCES Product(product_id),
    quantity INT NOT NULL
);

CREATE TABLE Cart(
	cart_item_id SERIAL PRIMARY KEY,
	user_id INT NOT NULL REFERENCES Users(user_id),
	product_id INT NOT NULL REFERENCES Product(product_id),
	quantity INT NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Review(
	review_id SERIAL PRIMARY KEY,
	user_id INT NOT NULL REFERENCES Users(user_id),
	product_id INT NOT NULL REFERENCES Product(product_id),
	rating DECIMAL(3,1) NOT NULL,
	comment text,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
