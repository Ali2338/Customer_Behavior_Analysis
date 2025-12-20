select gender, SUM(purchase_amount) as revenue
from customer_behaviour.customer group by gender

SELECT customer_id, purchase_amount
FROM customer_behaviour.customer
WHERE discount_applied = 'Yes'
  AND purchase_amount >= (
      SELECT AVG(purchase_amount)
      FROM customer_behaviour.customer
  );

SELECT 
    item_purchased, 
    ROUND(AVG(CAST(review_rating AS DECIMAL)), 2) AS `Average Product Review`
FROM customer_behaviour.customer
GROUP BY item_purchased
ORDER BY `Average Product Review` DESC
LIMIT 5;

SELECT shipping_type,
ROUND(AVG(CAST(purchase_amount AS DECIMAL)), 2)
FROM customer_behaviour.customer
WHERE shipping_type IN ('Standard','Express')
GROUP BY shipping_type

SELECT 
    subscription_status,
    COUNT(customer_id) AS total_customers,
    ROUND(AVG(purchase_amount), 2) AS avg_spend,
    ROUND(SUM(purchase_amount), 2) AS total_revenue
FROM customer_behaviour.customer
GROUP BY subscription_status
ORDER BY total_revenue DESC, avg_spend DESC;

SELECT item_purchased,
       ROUND( SUM(discount_applied = 'Yes') / COUNT(*) * 100, 2 ) AS discount_rate_percent
FROM `customer_behaviour`.`customer`
GROUP BY item_purchased
ORDER BY discount_rate_percent DESC
LIMIT 5;

WITH customer_type AS (
    SELECT 
        customer_id,
        previous_purchases,
        CASE
            WHEN previous_purchases = 1 THEN 'NEW'
            WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
            ELSE 'Loyal'
        END AS customer_segment
    FROM customer_behaviour.customer
)

SELECT 
    customer_segment, 
    COUNT(*) AS `Number of customers`
FROM customer_type
GROUP BY customer_segment;

WITH item_counts AS (
    SELECT 
        category,
        item_purchased,
        COUNT(customer_id) AS total_orders,
        ROW_NUMBER() OVER (
            PARTITION BY category 
            ORDER BY COUNT(customer_id) DESC
        ) AS item_rank
    FROM customer_behaviour.customer
    GROUP BY category, item_purchased
)

SELECT 
    item_rank,
    category,
    item_purchased,
    total_orders
FROM item_counts
WHERE item_rank <= 3;

SELECT subscription_status,
COUNT(customer_id) as `repeat_buyers`
FROM customer_behaviour.customer
WHERE previous_purchases > 5
GROUP BY subscription_status;

SELECT age_group,
SUM(purchase_amount) as `total_revenue`
FROM customer_behaviour.customer
GROUP BY age_group
ORDER BY total_revenue Desc












