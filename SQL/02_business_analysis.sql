# ============================================================
# SQL Analysis 1 — Overall Business KPIs
# ============================================================

SELECT 
    SUM(oi.net_sales) AS total_revenue,
    SUM(oi.profit) AS total_profit,
    COUNT(DISTINCT o.order_id) AS total_order,
    COUNT(DISTINCT o.customer_id) AS total_customer,
    round(SUM(oi.net_sales) / COUNT(DISTINCT o.order_id),2) AS AOV,
    round(SUM(oi.profit) / SUM(oi.net_sales) * 100 ,2) AS profit_margin
FROM
    orders AS o
        JOIN
    order_items AS oi ON o.order_id = oi.order_id
WHERE
    o.order_status = 'Delivered';
    
# ============================================================
# Yearly Performance
# ============================================================

SELECT 
    YEAR(o.order_date) AS year,
    SUM(oi.net_sales) AS revenue,
    SUM(oi.profit) AS profit,
    COUNT(DISTINCT o.order_id) AS orders,
    COUNT(DISTINCT o.customer_id) AS customer
FROM
    orders AS o
        JOIN
    order_items AS oi ON oi.order_id = o.order_id
WHERE
    order_status = 'Delivered'
GROUP BY YEAR(order_date)
ORDER BY year;

# =====================================================================
# YoY Growth
# =====================================================================

with yearly as(

SELECT 
    YEAR(o.order_date) AS year,
    SUM(oi.net_sales) AS revenue,
    SUM(oi.profit) AS profit,
    COUNT(DISTINCT o.order_id) AS orders,
    COUNT(DISTINCT o.customer_id) AS customer
FROM
    orders AS o
        JOIN
    order_items AS oi ON oi.order_id = o.order_id
WHERE
    order_status = 'Delivered'
GROUP BY YEAR(order_date) 
)
select year,
round(revenue / 83 / 1000000, 2) as revenue_usd_m,
round(profit / 83/ 1000000, 2) as profit_usd_m,
orders,
customer,
  ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY year))
        / LAG(revenue) OVER (ORDER BY year) * 100,
        2
    ) AS revenue_growth_pct,
    round(
    (profit - lag(profit) over (order by year)) 
    / lag(profit) over (order by year) * 100,
    2
    
    )as profit_growth_pct
    from yearly
    order by year;
    
# ============================================================
# Monthly Revenue Trend
# ============================================================

SELECT
    YEAR(o.order_date) AS year,
    MONTH(o.order_date) AS month,
    ROUND(SUM(oi.net_sales) / 83 / 1000000, 2) AS revenue_usd_m,
    COUNT(DISTINCT o.order_id) AS orders
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY YEAR(o.order_date), MONTH(o.order_date)
ORDER BY year, month;

# ============================================================
# Customer Analysis
# ============================================================

SELECT 
    o.customer_id,
    ROUND(SUM(oi.net_sales) / 83, 2) AS revenue_usd,
    ROUND(SUM(oi.profit) / 83, 2) AS profit_usd,
    COUNT(DISTINCT o.order_id) AS orders
FROM
    orders AS o
        JOIN
    order_items AS oi ON oi.order_id = o.order_id
WHERE
    o.order_status = 'Delivered'
GROUP BY o.customer_id
ORDER BY revenue_usd DESC LIMIT 10;

# ============================================================
# Top 10 Customer By Profit
# ============================================================

SELECT 
    o.customer_id,
    ROUND(SUM(oi.profit) / 83, 2) AS profit_usd,
    COUNT(DISTINCT o.order_id) AS orders
FROM
    orders AS o
        JOIN
    order_items AS oi ON oi.order_id = o.order_id
WHERE
    o.order_status = 'Delivered'
GROUP BY o.customer_id
ORDER BY profit_usd DESC LIMIT 10;

# ============================================================
# Top 10 Customer By Revenue
# ============================================================

SELECT 
    o.customer_id,
    ROUND(SUM(oi.net_sales) / 83, 2) AS revenue_usd,
    COUNT(DISTINCT o.order_id) AS orders
FROM
    orders AS o
        JOIN
    order_items AS oi ON oi.order_id = o.order_id
WHERE
    o.order_status = 'Delivered'
GROUP BY o.customer_id
ORDER BY revenue_usd DESC LIMIT 10;

# ============================================================
# Repeat vs One-Time Customers.
# ============================================================

with customer_orders as (
select customer_id,
count(distinct order_id) as total_orders
from orders
where order_status = "Delivered"
group by customer_id
)

select 
case when total_orders = 1 then "One-time Customer"
else "Repeat Customer"
end customer_type,
count(*) as customer_count,
round(
count(*) * 100 / sum(count(*)) over(),2
) as customer_pct

from customer_orders 
group by
 case
 when total_orders = 1 then "One-time Customer"
else "Repeat Customer"
end;

# ============================================================
# Product & Category Analysis.
# ============================================================

SELECT 
    p.category_clean AS category,
    ROUND(SUM(oi.net_sales) / 83 / 1000000, 2) AS revenue_usd_m,
    ROUND(SUM(oi.profit) / 83 / 1000000, 2) AS profit_usd_m,
    ROUND(SUM(oi.profit) / SUM(oi.net_sales) * 100,
            2) AS profit_margin_pct
FROM
    order_items AS oi
        JOIN
    products AS p ON p.product_id = oi.product_id
        JOIN
    orders AS o ON o.order_id = oi.order_id
WHERE
    o.order_status = 'Delivered'
GROUP BY p.category_clean
ORDER BY revenue_usd_m DESC;

# ============================================================
# Top 10 Products by Revenue.
# ============================================================
SELECT 
    p.product_id,
    p.product_name,
    ROUND(SUM(oi.net_sales) / 83, 2) AS revenue_usd,
    SUM(oi.quantity_clean) AS quantity_sold
FROM
    order_items AS oi
        JOIN
    products AS p ON p.product_id = oi.product_id
        JOIN
    orders AS o ON o.order_id = oi.order_id
WHERE
    o.order_status = 'Delivered'
GROUP BY p.product_id , p.product_name
ORDER BY revenue_usd DESC
LIMIT 10;

# ============================================================
# Top 10 Product By Profit
# ============================================================
SELECT 
    p.product_id,
    p.product_name,
    ROUND(SUM(oi.profit) / 83, 2) AS profit_usd,
    SUM(oi.quantity_clean) AS quantity_sold
FROM
    order_items AS oi
        JOIN
    products AS p ON p.product_id = oi.product_id
        JOIN
    orders AS o ON o.order_id = oi.order_id
WHERE
    o.order_status = 'Delivered'
GROUP BY p.product_id , p.product_name
ORDER BY profit_usd DESC
LIMIT 10;

# ============================================================
# Lowest-profit products
# ============================================================

SELECT 
    p.product_id,
    p.product_name,
    ROUND(SUM(oi.profit) / 83, 2) AS profit_usd,
    SUM(oi.quantity_clean) AS quantity_sold
FROM
    order_items AS oi
        JOIN
    products AS p ON p.product_id = oi.product_id
        JOIN
    orders AS o ON o.order_id = oi.order_id
WHERE
    o.order_status = 'Delivered'
GROUP BY p.product_id , p.product_name
ORDER BY profit_usd ASC
LIMIT 10;
