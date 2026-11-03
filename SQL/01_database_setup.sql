# creating the database for NovaCart
# ==================================
CREATE DATABASE NovaCart;
USE NovaCart;

# ============================
# creating customer table 
# ============================

CREATE TABLE customers (
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    city VARCHAR(100),
    city_clean VARCHAR(100),
    customer_segment VARCHAR(50),
    signup_date DATE
);

# ================================
# bulk insert
# ================================

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    customer_id,
    customer_name,
    city,
    city_clean,
    customer_segment,
    @signup_date
)
SET signup_date = STR_TO_DATE(TRIM(@signup_date), '%d-%m-%Y');


SELECT *
FROM customers
LIMIT 5;

SELECT COUNT(*) AS total_customers
FROM customers;

# =================================
# importing product table 
# =================================

USE novacart;

CREATE TABLE products (
    product_id VARCHAR(20),
    product_name VARCHAR(255),
    category VARCHAR(100),
    category_clean VARCHAR(100),
    sub_category VARCHAR(50),
    unit_cost DECIMAL(12,2),
    unit_price DECIMAL(12,2)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) AS total_products
FROM products;

SELECT *
FROM products
LIMIT 5;

# =============================
# importing orders table 
# =============================

CREATE TABLE orders (
    order_id VARCHAR(20),
    customer_id VARCHAR(20),
    order_date DATE,
    region VARCHAR(50),
    channel VARCHAR(50),
    payment_method VARCHAR(50),
    order_status VARCHAR(30),
    delivery_days INT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    customer_id,
    @order_date,
    region,
    channel,
    payment_method,
    order_status,
    delivery_days
)
SET order_date = STR_TO_DATE(TRIM(@order_date), '%d-%m-%Y');



select count(*) as total_Count
from orders;

# ===================================
# importing order_items
# ===================================

DROP TABLE IF EXISTS order_items;

CREATE TABLE order_items (
    order_item_id VARCHAR(20),
    order_id VARCHAR(20),
    product_id VARCHAR(20),
    discount_pct DECIMAL(10,4),
    discount_pct_clean DECIMAL(10,4),
    quantity_clean INT,
    unit_cost DECIMAL(12,2),
    unit_price DECIMAL(12,2),
    gross_sales DECIMAL(14,2),
    discount_amount DECIMAL(14,2),
    net_sales DECIMAL(14,2),
    cost DECIMAL(14,2),
    profit DECIMAL(14,2)
);


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/order_items.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_item_id,
    order_id,
    product_id,
    @discount_pct,
    @discount_pct_clean,
    quantity_clean,
    unit_cost,
    unit_price,
    gross_sales,
    discount_amount,
    net_sales,
    cost,
    profit
)
SET
    discount_pct = NULLIF(REPLACE(TRIM(@discount_pct), '%', ''), ''),
    discount_pct_clean = NULLIF(REPLACE(TRIM(@discount_pct_clean), '%', ''), '');
    
    

select count(*) as total_Count
from order_items;