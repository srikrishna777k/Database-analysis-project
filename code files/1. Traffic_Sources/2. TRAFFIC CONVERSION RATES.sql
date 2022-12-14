#2.  TRAFFIC CONVERSION RATES
SELECT
	COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
        COUNT(DISTINCT orders.order_id) AS orders,
        COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) AS session_to_order_conv_rt
FROM website_sessions
	LEFT JOIN orders
		ON orders.website_session_id = website_sessions.website_session_id
WHERE
	website_sessions.utm_source = 'gsearch' AND
        website_sessions.utm_campaign = 'nonbrand' AND
        website_sessions.created_at < '2012-04-14'


