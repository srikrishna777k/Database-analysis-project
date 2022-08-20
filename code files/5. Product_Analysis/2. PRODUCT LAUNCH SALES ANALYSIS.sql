
#2. PRODUCT LAUNCH SALES ANALYSIS
SELECT
    YEAR(website_sessions.created_at) AS yr,
    MONTH(website_sessions.created_at) AS mo,
    COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) AS conv_rate,
    SUM(orders.price_usd) / COUNT(DISTINCT website_sessions.website_session_id) AS revenue_per_session,
    COUNT(DISTINCT CASE WHEN orders.primary_product_id = 1 THEN website_sessions.website_session_id ELSE NULL END) AS product_one_orders,
    COUNT(DISTINCT CASE WHEN orders.primary_product_id = 2 THEN website_sessions.website_session_id ELSE NULL END) AS product_two_orders
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at > '2012-04-01' AND website_sessions.created_at < '2013-04-05'
GROUP BY 1,2
;
