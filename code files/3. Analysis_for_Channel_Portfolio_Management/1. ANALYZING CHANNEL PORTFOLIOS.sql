#1. ANALYZING CHANNEL PORTFOLIOS
SELECT
    -- YEARWEEK(created_at) AS year_week,
    MIN(DATE(created_at)) AS week_start_date,
    COUNT(DISTINCT CASE WHEN website_sessions.utm_source = 'gsearch' THEN website_sessions.website_session_id ELSE NULL END) AS gsearch_sessions,
    COUNT(DISTINCT CASE WHEN website_sessions.utm_source = 'bsearch' THEN website_sessions.website_session_id ELSE NULL END) AS bsearch_sessions
FROM
    website_sessions
WHERE website_sessions.created_at < '2012-11-29'
    AND website_sessions.created_at > '2012-08-22'
    AND utm_campaign = 'nonbrand' 
GROUP BY YEARWEEK(created_at);