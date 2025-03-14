CREATE DATABASE IF NOT EXISTS marcus_bike_shop;
USE marcus_bike_shop;

-- Products table: stores product details.
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    base_price DECIMAL(10,2) NOT NULL,
    category ENUM('bicycle', 'skis', 'surfboards'),
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Options table: stores customizable options (e.g., "Rim Color").
CREATE TABLE options (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    product_id INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Option values table: stores possible values for each option (e.g., "Blue", "Red").
CREATE TABLE option_values (
    id INT AUTO_INCREMENT PRIMARY KEY,
    option_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    price_modifier DECIMAL(10,2) DEFAULT 0,
    in_stock BOOLEAN DEFAULT 1,
    FOREIGN KEY (option_id) REFERENCES options(id) ON DELETE CASCADE
);

-- Pricing rules table: handles dynamic pricing for combinations.
CREATE TABLE pricing_rules (
    id INT AUTO_INCREMENT PRIMARY KEY,
    base_option_value_id INT NOT NULL,
    dependent_option_value_id INT NOT NULL,
    additional_cost DECIMAL(10,2),
    FOREIGN KEY (base_option_value_id) REFERENCES option_values(id),
    FOREIGN KEY (dependent_option_value_id) REFERENCES option_values(id)
);

-- Cart table: stores items added to the cart.
CREATE TABLE cart (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    options_selected JSON,
    total_price DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id)
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Orders table: stores completed orders.
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    cart_snapshot JSON,
    total_price DECIMAL(10,2),
    status ENUM('pending', 'paid', 'shipped', 'delivered', 'canceled'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Users table: stores user accounts.
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    password VARCHAR(255) NOT NULL
);
