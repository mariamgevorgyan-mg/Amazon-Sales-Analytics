ALTER TABLE public.amazon_sales
ALTER COLUMN discount TYPE VARCHAR(20);
SELECT COUNT(*) AS total_rows
FROM public.amazon_sales;
SELECT *
FROM public.amazon_sales
LIMIT 10;
SELECT
    SUM(total_amount) AS total_revenue
FROM public.amazon_sales;
SELECT
    COUNT(DISTINCT order_id) AS total_orders
FROM public.amazon_sales;
SELECT
    ROUND(AVG(total_amount), 2) AS average_order_value
FROM public.amazon_sales;
SELECT
    category,
    ROUND(SUM(total_amount), 2) AS total_revenue
FROM public.amazon_sales
GROUP BY category
ORDER BY total_revenue DESC;
SELECT
    category,
    COUNT(DISTINCT order_id) AS total_orders
FROM public.amazon_sales
GROUP BY category
ORDER BY total_orders DESC;
SELECT
    category,
    ROUND(AVG(total_amount), 2) AS average_order_value
FROM public.amazon_sales
GROUP BY category
ORDER BY average_order_value DESC;
SELECT
    DATE_TRUNC('month', order_date) AS month,
    ROUND(SUM(total_amount), 2) AS monthly_revenue
FROM public.amazon_sales
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month;
SELECT
    EXTRACT(YEAR FROM order_date) AS year,
    ROUND(SUM(total_amount), 2) AS annual_revenue
FROM public.amazon_sales
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY year;
WITH yearly_revenue AS (
    SELECT
        EXTRACT(YEAR FROM order_date) AS year,
        SUM(total_amount) AS revenue
    FROM public.amazon_sales
    GROUP BY EXTRACT(YEAR FROM order_date)
)
SELECT
    year,
    ROUND(revenue, 2) AS annual_revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY year))
        / LAG(revenue) OVER (ORDER BY year) * 100,
        2
    ) AS revenue_growth_pct
FROM yearly_revenue
ORDER BY year;
SELECT
    payment_method,
    COUNT(*) AS total_orders,
    ROUND(SUM(total_amount), 2) AS total_revenue
FROM public.amazon_sales
GROUP BY payment_method
ORDER BY total_revenue DESC;
SELECT
    order_status,
    COUNT(*) AS total_orders,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM public.amazon_sales),
        2
    ) AS percentage
FROM public.amazon_sales
GROUP BY order_status
ORDER BY total_orders DESC;
SELECT
    ROUND(
        COUNT(*) FILTER (WHERE order_status = 'Returned') * 100.0
        / COUNT(*), 2
    ) AS return_rate,
    ROUND(
        COUNT(*) FILTER (WHERE order_status = 'Cancelled') * 100.0
        / COUNT(*), 2
    ) AS cancellation_rate
FROM public.amazon_sales;
SELECT
    product_name,
    SUM(quantity) AS units_sold,
    ROUND(SUM(total_amount), 2) AS total_revenue
FROM public.amazon_sales
GROUP BY product_name
ORDER BY total_revenue DESC
LIMIT 10;
SELECT
    product_name,
    SUM(quantity) AS units_sold
FROM public.amazon_sales
GROUP BY product_name
ORDER BY units_sold DESC
LIMIT 10;
SELECT
    brand,
    SUM(quantity) AS units_sold,
    ROUND(SUM(total_amount), 2) AS total_revenue
FROM public.amazon_sales
GROUP BY brand
ORDER BY total_revenue DESC;
SELECT
    country,
    COUNT(*) AS total_orders,
    ROUND(SUM(total_amount), 2) AS total_revenue
FROM public.amazon_sales
GROUP BY country
ORDER BY total_revenue DESC;
SELECT
    country,
    state,
    COUNT(*) AS total_orders,
    ROUND(SUM(total_amount), 2) AS total_revenue
FROM public.amazon_sales
GROUP BY country, state
ORDER BY total_revenue DESC
LIMIT 15;
SELECT
    country,
    state,
    city,
    COUNT(*) AS total_orders,
    ROUND(SUM(total_amount), 2) AS total_revenue
FROM public.amazon_sales
GROUP BY country, state, city
ORDER BY total_revenue DESC
LIMIT 15;
SELECT
    seller_id,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS units_sold,
    ROUND(SUM(total_amount), 2) AS total_revenue
FROM public.amazon_sales
GROUP BY seller_id
ORDER BY total_revenue DESC
LIMIT 10;
SELECT
    category,
    ROUND(
        AVG(NULLIF(REPLACE(discount, '%', ''), '')::NUMERIC),
        2
    ) AS average_discount_pct
FROM public.amazon_sales
GROUP BY category
ORDER BY average_discount_pct DESC;
SELECT
    order_status,
    COUNT(*) AS total_orders,
    ROUND(SUM(total_amount), 2) AS total_revenue,
    ROUND(AVG(total_amount), 2) AS average_order_value
FROM public.amazon_sales
GROUP BY order_status
ORDER BY total_revenue DESC;
SELECT
    TO_CHAR(order_date, 'YYYY-MM') AS month,
    COUNT(DISTINCT order_id) AS total_orders
FROM public.amazon_sales
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY month;
SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE order_id IS NULL) AS missing_order_ids,
    COUNT(*) FILTER (WHERE order_date IS NULL) AS missing_dates,
    COUNT(*) FILTER (WHERE product_name IS NULL) AS missing_products,
    COUNT(*) FILTER (WHERE quantity IS NULL) AS missing_quantities,
    COUNT(*) FILTER (WHERE total_amount IS NULL) AS missing_amounts,
    COUNT(*) FILTER (WHERE quantity <= 0) AS invalid_quantities,
    COUNT(*) FILTER (WHERE unit_price < 0) AS negative_prices
FROM public.amazon_sales;
SELECT
    COUNT(*) - COUNT(DISTINCT order_id) AS duplicate_order_ids
FROM public.amazon_sales;
SELECT
    COUNT(*) - COUNT(DISTINCT order_id) AS duplicate_order_ids
FROM public.amazon_sales;
SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM public.amazon_sales;
SELECT DISTINCT category
FROM public.amazon_sales
ORDER BY category;
SELECT DISTINCT order_status
FROM public.amazon_sales
ORDER BY order_status;
SELECT DISTINCT payment_method
FROM public.amazon_sales
ORDER BY payment_method;