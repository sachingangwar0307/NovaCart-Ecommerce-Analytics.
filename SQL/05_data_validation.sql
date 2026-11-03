# ==============================================================
# Data validation
# ==============================================================

select count(*) as total_count_cus
from customers;
# ===========================================================================

select count(*) as total_count_pro
from products;
# ===========================================================================

select count(*) as total_count_ord
from orders;
# ===========================================================================

select count(*) as total_count_ord_ite
from order_items;

# ===========================================================
# Duplicates 
# ===========================================================

select customer_id as cnt_id
from customers
group by customer_id
having count(*) > 1;
# ===========================================================================

select order_id as cnt_id
from orders
group by order_id
having count(*) > 1;
# ===========================================================================

select product_id as cnt_id
from products	
group by product_id
having count(*) > 1;
# ===========================================================================

select order_item_id as cnt_id
from order_items
group by order_item_id
having count(*) > 1;

# =================================================================
# checking from relationships
# =================================================================

SELECT COUNT(*) AS unmatched_customers
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
# ===========================================================================

SELECT COUNT(*) AS unmatched_orders
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;
# ========================================================================

SELECT COUNT(*) AS unmatched_products
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

# ========================================================================
# final financial validation
# =========================================================================

SELECT 
    COUNT(*) AS total_items,
    SUM(gross_sales) AS gross_sales,
    SUM(discount_amount) AS discount_amount,
    SUM(net_sales) AS net_sales,
    SUM(cost) AS total_cost,
    SUM(profit) AS total_profit
FROM order_items;
# ============================================================================

SELECT COUNT(*) AS incorrect_net_sales
FROM order_items
WHERE ROUND(gross_sales - discount_amount, 2) <> ROUND(net_sales, 2);
# ==============================================================================

SELECT COUNT(*) AS incorrect_profit
FROM order_items
WHERE ROUND(net_sales - cost, 2) <> ROUND(profit, 2);
# ================================================================================
# END
# ===============================================================================