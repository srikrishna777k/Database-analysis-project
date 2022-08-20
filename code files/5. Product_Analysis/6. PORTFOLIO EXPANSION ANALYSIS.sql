
#6. PORTFOLIO EXPANSION ANALYSIS
SELECT
	CASE
		WHEN website_sessions.created_at < '2013-12-12' THEN 'A. Pre_Birthday_Bear'
        WHEN website_sessions.created_at >= '2013-12-12' THEN 'B. Post_Birthday_Bear'
        ELSE 'uh oh...check logic'
	END AS time_period,
    COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) AS conv_rate,
    SUM(orders.price_usd) / COUNT(DISTINCT orders.order_id) AS aov,
    SUM(orders.items_purchased) / COUNT(DISTINCT orders.order_id) AS products_per_order,
    SUM(orders.price_usd) / COUNT(DISTINCT website_sessions.website_session_id) AS revenue_per_session
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at BETWEEN '2013-11-12' AND '2014-01-12'
GROUP BY 1
;
