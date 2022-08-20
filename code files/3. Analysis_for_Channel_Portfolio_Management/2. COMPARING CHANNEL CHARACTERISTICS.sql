#2. COMPARING CHANNEL CHARACTERISTICS
SELECT
    utm_source,
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN website_sessions.device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END) AS mobile_sessions,
    COUNT(DISTINCT CASE WHEN website_sessions.device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id)AS pct_mobile
FROM
    website_sessions
WHERE website_sessions.created_at < '2012-11-30'
    AND website_sessions.created_at > '2012-08-22'
    AND utm_campaign = 'nonbrand' 
GROUP BY utm_source;