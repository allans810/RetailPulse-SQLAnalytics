use sqlplus;

-- BR1 - Calculate the total revenue generated in 2024 and 2025.
SELECT 
    YEAR(order_date) AS year,
    SUM(total_amount) AS total_revenue
FROM orders
WHERE YEAR(order_date) IN (2024, 2025)
GROUP BY YEAR(order_date)
ORDER BY year;

-- BR2 - Find the top 5 customers by total spending.
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 5;

-- BR3 -  Identify the best-selling product by total quantity sold.
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    SUM(oi.quantity) AS total_quantity_sold
FROM products p
JOIN order_items oi 
    ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_quantity_sold DESC
LIMIT 1;

-- BR4 - Compute total revenue for each customer city.
SELECT 
    c.city,
    SUM(o.total_amount) AS total_revenue
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
GROUP BY c.city
ORDER BY total_revenue DESC;

-- BR5 - Show each order with total items purchased and total order value.
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    o.order_id,
    SUM(oi.quantity) AS total_quantity,
    SUM(oi.total_price) AS total_order_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN customers c
    ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name, o.order_id
ORDER BY 
    total_order_value DESC;

-- BR6 - Generate monthly revenue for all months in 2024–2025.
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS year__month,
    SUM(total_amount) AS monthly_revenue
FROM orders
GROUP BY year__month
ORDER BY year__month;

-- BR7 - List all customers who have spent more than ₹50,000.
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name
HAVING 
    total_spent > 50000
ORDER BY 
    total_spent DESC;

-- BR8 - Calculate payment success rate for each payment method.
SELECT 
    payment_method,
    (SUM(CASE WHEN payment_status = 'Success' THEN 1 ELSE 0 END) 
     / COUNT(*)) * 100 AS success_rate
FROM payments
GROUP BY payment_method
ORDER BY success_rate DESC;

-- BR9 - Show total revenue and quantity sold for each product category.
SELECT 
    p.category,
    SUM(oi.total_price) AS total_revenue, 
    SUM(oi.quantity) AS total_quantity
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC, total_quantity DESC;

-- BR10 - Rank customers by total spending using a window function.
WITH customer_totals AS (
    SELECT 
        c.customer_id,
        SUM(o.total_amount) AS total_revenue
    FROM customers c
    JOIN orders o 
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_id
)
SELECT 
    customer_id,
    total_revenue,
    RANK() OVER (ORDER BY total_revenue DESC) AS customer_rank
FROM customer_totals;







    
