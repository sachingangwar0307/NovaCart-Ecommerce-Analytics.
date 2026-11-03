# ============================================================
# Operations Analysis
# ============================================================
select 
order_status,
count(distinct order_id) as order_count,
round(
count(distinct order_id) *100 / sum(count(distinct order_id)) over (), 2
) as order_pct
from orders
group by order_status
order by order_count desc;

# ============================================================
# Delivery Performance
# ============================================================

SELECT 
    ROUND(AVG(delivery_days), 2) AS avg_delivery_Day
FROM
    orders
WHERE
    order_status = 'Delivered'
    
