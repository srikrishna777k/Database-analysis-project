#3. CROSS CHANNEL BID OPTIMIZATION
SELECT
	website_sessions.device_type,
    website_sessions.utm_source,
    COUNT(website_sessions.website_session_id) AS sessions,
    COUNT(order_id) AS orders,
    COUNT(order_id) / COUNT(website_sessions.website_session_id) AS conv_rate
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at BETWEEN '2012-08-22' AND '2012-09-18'
	AND website_sessions.utm_campaign = 'nonbrand'
GROUP BY 1, 2
;

