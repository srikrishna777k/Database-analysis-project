#4. CHANNEL PORTFOLIO TRENDS
SELECT
	MIN(DATE(created_at)) AS week_start_date,
    COUNT(DISTINCT CASE WHEN (device_type = 'desktop' AND utm_source = 'gsearch') THEN website_session_id ELSE NULL END) AS g_dtop_sessions,
    COUNT(DISTINCT CASE WHEN (device_type = 'desktop' AND utm_source = 'bsearch') THEN website_session_id ELSE NULL END) AS b_dtop_sessions,
    COUNT(DISTINCT CASE WHEN (device_type = 'desktop' AND utm_source = 'bsearch') THEN website_session_id ELSE NULL END) /
		COUNT(DISTINCT CASE WHEN (device_type = 'desktop' AND utm_source = 'gsearch') THEN website_session_id ELSE NULL END) AS b_pct_of_g_dtop,
    COUNT(DISTINCT CASE WHEN (device_type = 'mobile' AND utm_source = 'gsearch') THEN website_session_id ELSE NULL END) AS g_mob_sessions,
    COUNT(DISTINCT CASE WHEN (device_type = 'mobile' AND utm_source = 'bsearch') THEN website_session_id ELSE NULL END) AS b_mob_sessions,
    COUNT(DISTINCT CASE WHEN (device_type = 'mobile' AND utm_source = 'bsearch') THEN website_session_id ELSE NULL END) /
		COUNT(DISTINCT CASE WHEN (device_type = 'mobile' AND utm_source = 'gsearch') THEN website_session_id ELSE NULL END) AS b_pct_of_g_mob
FROM website_sessions
WHERE created_at > '2012-11-04' AND created_at < '2012-12-22'
	AND website_sessions.utm_campaign = 'nonbrand'
GROUP BY
	YEARWEEK(created_at)
;
