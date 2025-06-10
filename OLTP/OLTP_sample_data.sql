-- Some sample data for OLTP database
INSERT INTO Users (first_name, last_name, email, password_hash, phone, country, gender) VALUES
('John', 'Smith', 'john.smith@example.com', 'hashed_password_1', '+1234567890', 'USA', 'male'),
('Emily', 'Johnson', 'emily.j@example.com', 'hashed_password_2', '+44123456789', 'UK', 'female'),
('Michael', 'Brown', 'michael.b@example.com', 'hashed_password_3', '+61234567890', 'Australia', 'male'),
('Sophia', 'Williams', 'sophia.w@example.com', 'hashed_password_4', '+81345678901', 'Japan', 'female'),
('David', 'Jones', 'david.j@example.com', 'hashed_password_5', '+49123456789', 'Germany', 'male'),
('Olivia', 'Garcia', 'olivia.g@example.com', 'hashed_password_6', '+33123456789', 'France', 'female'),
('Daniel', 'Miller', 'daniel.m@example.com', 'hashed_password_7', '+14161234567', 'Canada', 'male'),
('Emma', 'Davis', 'emma.d@example.com', 'hashed_password_8', '+39345678901', 'Italy', 'female'),
('James', 'Rodriguez', 'james.r@example.com', 'hashed_password_9', '+52123456789', 'Mexico', 'male'),
('Ava', 'Martinez', 'ava.m@example.com', 'hashed_password_10', '+34678901234', 'Spain', 'female');

INSERT INTO Payment (method_name) VALUES
('Credit Card'),
('PayPal'),
('Bank Transfer'),
('Cash on Delivery');

INSERT INTO Category (category_name, description) VALUES
('Sofas', 'Comfortable seating for your living room'),
('Beds', 'Various types of beds for a good night sleep'),
('Tables', 'Dining tables, coffee tables, and more'),
('Chairs', 'Comfortable chairs for dining or office'),
('Wardrobes', 'Storage solutions for your clothes'),
('Bookshelves', 'Stylish storage for your books and decor');

INSERT INTO Brand (brand_name) VALUES
('IKEA'),
('Ashley Furniture'),
('Herman Miller'),
('West Elm'),
('Ethan Allen'),
('La-Z-Boy');

INSERT INTO Product (product_name, brand, warranty_period, product_weight, price, product_description) VALUES
('Ektorp Sofa', 1, '5 years', 45.5, 599.99, 'Comfortable 3-seater sofa with removable covers'),
('Hemnes Bed Frame', 1, '10 years', 68.2, 399.99, 'Solid wood bed frame with 4 storage drawers'),
('Malm Dining Table', 1, '5 years', 32.7, 249.99, 'Modern rectangular dining table for 6 people'),
('Aeron Office Chair', 3, '12 years', 20.1, 1299.99, 'Ergonomic office chair with adjustable features'),
('Parker Dining Chair', 4, '5 years', 8.5, 199.99, 'Elegant dining chair with upholstered seat'),
('Brimnes Wardrobe', 1, '5 years', 55.3, 299.99, 'Spacious wardrobe with mirrored doors'),
('Billy Bookshelf', 1, '5 years', 42.0, 89.99, 'Classic bookshelf with adjustable shelves'),
('Eames Lounge Chair', 3, 'Lifetime', 28.6, 5499.99, 'Iconic mid-century modern lounge chair'),
('Tvättboll Coffee Table', 1, '2 years', 15.8, 129.99, 'Minimalist round coffee table'),
('Recliner Sofa', 6, '7 years', 72.4, 899.99, 'Comfortable reclining sofa with power controls'),
('Farmhouse Dining Table', 5, '10 years', 48.9, 1199.99, 'Rustic solid wood dining table'),
('Storage Bed', 2, '5 years', 85.2, 799.99, 'King size bed with ample under-bed storage');

INSERT INTO Product_Category (product_id, category_id) VALUES
(1, 1), 
(2, 2), 
(3, 3), 
(4, 4), 
(5, 4), 
(6, 5), 
(7, 6), 
(8, 4), 
(9, 3), 
(10, 1), 
(11, 3), 
(12, 2);

INSERT INTO Products_Inventory (product_id, quantity, created_at, updated_at) VALUES
(1, 25, '2024-03-01 10:00:00', '2024-03-05 14:30:00'),
(2, 18, '2024-03-01 10:00:00', '2024-03-08 09:15:00'),
(3, 32, '2024-03-01 10:00:00', '2024-03-12 11:00:00'),
(4, 8, '2024-03-01 10:00:00', '2024-03-15 16:45:00'),
(5, 45, '2024-03-01 10:00:00', '2024-03-18 10:20:00'),
(6, 22, '2024-03-01 10:00:00', '2024-03-21 08:00:00'),
(7, 60, '2024-03-01 10:00:00', '2024-03-24 13:10:00'),
(8, 5, '2024-03-01 10:00:00', '2024-03-27 17:05:00'),
(9, 28, '2024-03-01 10:00:00', '2024-03-30 09:40:00'),
(10, 12, '2024-03-01 10:00:00', '2024-04-02 12:00:00'),
(11, 9, '2024-03-01 10:00:00', '2024-04-05 15:30:00'),
(12, 15, '2024-03-01 10:00:00', '2024-04-08 11:55:00');

INSERT INTO Cart (user_id, product_id, quantity) VALUES
(1, 3, 1), (1, 5, 4),
(2, 1, 1),
(3, 7, 2), (3, 9, 1),
(4, 4, 1),
(5, 2, 1), (5, 6, 1),
(7, 10, 1),
(9, 11, 1), (9, 12, 1);

INSERT INTO Review (user_id, product_id, rating, comment) VALUES
(1, 3, 4.5, 'Great table, very sturdy but a bit difficult to assemble'),
(2, 1, 5.0, 'Love this sofa! So comfortable and easy to clean'),
(3, 7, 3.5, 'Good value for money but shelves could be sturdier'),
(4, 4, 5.0, 'Worth every penny for my home office'),
(5, 2, 4.0, 'Nice bed frame with great storage, took a while to assemble'),
(6, 5, 4.5, 'Beautiful chairs that are surprisingly comfortable'),
(7, 10, 3.0, 'Comfortable but the mechanism is a bit noisy'),
(8, 8, 5.0, 'Absolute perfection, a true design classic'),
(9, 11, 4.0, 'Beautiful craftsmanship, arrived with a small scratch'),
(10, 6, 4.5, 'Great wardrobe, lots of space and the mirrors are perfect');

-- Assuming the 'Orders' table and its referenced tables (Payment, Users) are already created.

INSERT INTO Orders (payment_method_id, order_status, user_id, total_amount, delivery_address, order_date) VALUES
(1, 'delivered', 1, 899.97, '123 Main St, New York, USA', '2024-01-15 10:30:00'),
(2, 'delivered', 2, 599.99, '45 Park Lane, London, UK', '2024-01-20 14:00:00'),
(3, 'processing', 3, 309.97, '78 George St, Sydney, Australia', '2024-02-01 09:15:00'),
(1, 'shipped', 4, 1299.99, '22 Sakura Ave, Tokyo, Japan', '2024-02-05 11:45:00'),
(4, 'pending', 5, 699.98, '10 Berliner Str, Berlin, Germany', '2024-02-10 16:20:00'),
(1, 'delivered', 6, 199.99, '15 Rue de Paris, Paris, France', '2024-02-18 10:00:00'),
(2, 'delivered', 7, 899.99, '100 Queen St, Toronto, Canada', '2024-03-01 13:30:00'),
(1, 'delivered', 8, 5499.99, '5 Via Roma, Rome, Italy', '2024-03-08 08:00:00'),
(3, 'pending', 9, 2399.98, '20 Avenida Reforma, Mexico City, Mexico', '2024-03-15 17:00:00'),
(1, 'delivered', 10, 299.99, '8 Plaza Mayor, Madrid, Spain', '2024-03-22 11:00:00'),
(2, 'delivered', 1, 249.99, '123 Main St, New York, USA', '2024-04-01 09:45:00'),
(1, 'shipped', 3, 89.99, '78 George St, Sydney, Australia', '2024-04-05 14:10:00'),
(4, 'delivered', 5, 1199.99, '10 Berliner Str, Berlin, Germany', '2024-04-12 16:55:00'),
(1, 'cancelled', 7, 129.99, '100 Queen St, Toronto, Canada', '2024-04-18 10:20:00'),
(2, 'refunded', 9, 799.99, '20 Avenida Reforma, Mexico City, Mexico', '2024-04-25 13:05:00');

INSERT INTO Order_Item (order_id, product_id, quantity) VALUES
(1, 3, 1), (1, 5, 2),
(2, 1, 1),
(3, 7, 1), (3, 9, 1),
(4, 4, 1),
(5, 2, 1), (5, 6, 1),
(6, 5, 1),
(7, 10, 1),
(8, 8, 1),
(9, 11, 1), (9, 12, 1),
(10, 6, 1),
(11, 3, 1),
(12, 7, 1),
(13, 11, 1),
(14, 9, 1),
(15, 12, 1);