#7. ANALYZING CONVERSION FUNNEL TESTS
#STEP 1: finding the first time /billing-2 was seen
SELECT
	MIN(created_at) AS first_created_at,
        MIN(website_pageview_id) AS first_pv_id
FROM website_pageviews
WHERE pageview_url = '/billing-2';

#STEP 2: final test analysis output
SELECT
    billing_version_seen,
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT order_id) AS orders,
    COUNT(DISTINCT order_id)/COUNT(DISTINCT website_session_id) AS billing_to_order_rt
FROM(
SELECT 
    website_pageviews.website_session_id,
    website_pageviews.pageview_url AS billing_version_seen,
    orders.order_id
FROM website_pageviews
    LEFT JOIN orders
        ON website_pageviews.website_session_id = orders.website_session_id
WHERE website_pageviews.website_pageview_id >= 53550
    AND website_pageviews.created_at < '2012-11-10'
    AND website_pageviews.pageview_url IN ('/billing','/billing-2')
) AS billing_sessions_w_orders
GROUP BY 
    billing_version_seen
;
