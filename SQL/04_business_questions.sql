# ============================================================
# Business question
# ============================================================
# Q1). Which regions are driving NovaCart's revenue and profit, and where are the performance gaps?
# ============================================================

SELECT 
    o.region,
    ROUND(SUM(oi.net_sales) / 83 / 1000000, 2) AS revenue_usd_m,
    ROUND(SUM(oi.profit) / 83 / 1000000, 2) AS profit_usd_m,
    COUNT(DISTINCT o.order_id) AS orders,
    COUNT(DISTINCT o.customer_id) AS customers,
    ROUND(SUM(oi.profit) / SUM(oi.net_sales) * 100,
            2) AS profit_margin_pct
FROM
    orders AS o
        JOIN
    order_items AS oi ON oi.order_id = o.order_id
WHERE
    o.order_status = 'Delivered'
GROUP BY o.region
ORDER BY revenue_usd_m DESC;

# ==============================================================
# Q2). How does delivery performance vary across regions?
# ==============================================================

SELECT 
    region,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(AVG(delivery_days), 2) AS avg_delivery_days
FROM
    orders
WHERE
    order_status = 'Delivered'
GROUP BY region
ORDER BY avg_delivery_days;

# ============================================================
# Q3). Which region has the highest cancellation rate?
#=============================================================

SELECT 
    region,
    COUNT(DISTINCT order_id) AS orders,
    SUM(CASE
        WHEN order_status = 'Cancelled' THEN 1
        ELSE 0
    END) AS cancelled_order,
    ROUND(SUM(CASE
                WHEN order_status = 'Cancelled' THEN 1
                ELSE 0
            END) / COUNT(DISTINCT order_id) * 100,
            2) AS cancelled_rate_pct
FROM
    orders
GROUP BY region
ORDER BY cancelled_rate_pct desc;

# =======================================================
# Q4). Which region has the highest return rate? 
# =======================================================


SELECT 
    region,
    COUNT(DISTINCT order_id) AS orders,
    SUM(CASE
        WHEN order_status = 'Returned' THEN 1
        ELSE 0
    END) AS Returned_order,
    ROUND(SUM(CASE
                WHEN order_status = 'Returned' THEN 1
                ELSE 0
            END) / COUNT(DISTINCT order_id) * 100,
            2) AS Returned_rate_pct
FROM
    orders
GROUP BY region
ORDER BY Returned_rate_pct desc;

# ==============================================
# Q5). Which region has the highest combined cancellation and return rate?
# ==============================================

SELECT 
    region,
    COUNT(DISTINCT order_id) AS orders,
    SUM(CASE
        WHEN order_status = 'Cancelled' THEN 1
        ELSE 0
    END) AS cancelled_order,
    SUM(CASE
        WHEN order_status = 'Returned' THEN 1
        ELSE 0
    END) AS Returned_order,
    ROUND((SUM(CASE
                WHEN order_status = 'Cancelled' THEN 1
                ELSE 0
            END) + SUM(CASE
                WHEN order_status = 'Returned' THEN 1
                ELSE 0
            END)) / COUNT(DISTINCT order_id) * 100,
            2) AS unsuccessful_rate_pct
FROM
    orders
GROUP BY region
ORDER BY unsuccessful_rate_pct desc;
    