#2. IDENTIFYING TOP ENTRY PAGES
CREATE TEMPORARY TABLE first_pageview_per_session
SELECT
	website_session_id,
    MIN(website_pageview_id) AS first_pageview
FROM website_pageviews
WHERE created_at < '2012-06-12'
GROUP BY website_session_id;

SELECT
	website_pageviews.pageview_url AS landing_page_url,
    COUNT(DISTINCT first_pageview_per_session.website_session_id) AS sessions_hitting_page
FROM first_pageview_per_session
	LEFT JOIN website_pageviews
		ON website_pageviews.website_pageview_id = first_pageview_per_session.first_pageview
GROUP BY
	website_pageviews.pageview_url;
    
