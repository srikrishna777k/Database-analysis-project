#4. ANALYZING LANDING PAGE TESTS
#STEP 0: find out when the new page /lander launched
SELECT
	created_at AS first_created_at,
    website_pageview_id AS first_pageview_id
FROM website_pageviews
WHERE pageview_url = '/lander-1';

#STEP 1: finding the first website_pageview_id for relevant sessions
CREATE TEMPORARY TABLE first_pageview_lander1
SELECT
	website_pageviews.website_session_id,
    MIN(website_pageviews.website_pageview_id) AS min_pageview_id
FROM website_pageviews
	INNER JOIN website_sessions
		ON website_pageviews.website_session_id = website_sessions.website_session_id
        AND website_pageviews.created_at < '2012-07-28' #as per assignment
        AND website_pageviews.website_pageview_id > 23504 #as per STEP 0
        AND website_sessions.utm_source = 'gsearch'
        AND website_sessions.utm_campaign = 'nonbrand'
GROUP BY
	website_pageviews.website_session_id;

#STEP 2: identifying landing page of each session
CREATE TEMPORARY TABLE sessions_w_landing_page_lander1
SELECT
	first_pageview_lander1.website_session_id,
    website_pageviews.pageview_url AS landing_page
FROM first_pageview_lander1
	LEFT JOIN website_pageviews
		ON first_pageview_lander1.min_pageview_id = website_pageviews.website_pageview_id
WHERE website_pageviews.pageview_url IN ('/home', '/lander-1');

#STEP 3: counting pageviews for each session, to identify "bounces"
CREATE TEMPORARY TABLE bounced_sessions_lander1
SELECT
	sessions_w_landing_page_lander1.website_session_id,
    sessions_w_landing_page_lander1.landing_page,
    COUNT(website_pageviews.website_pageview_id) AS count_of_pages_viewed
FROM sessions_w_landing_page_lander1
	LEFT JOIN website_pageviews
		ON website_pageviews.website_session_id = sessions_w_landing_page_lander1.website_session_id
GROUP BY
	sessions_w_landing_page_lander1.website_session_id,
    sessions_w_landing_page_lander1.landing_page
HAVING
	COUNT(website_pageviews.website_pageview_id) = 1;

#STEP 4: summarizing by counting total sessions and bounced sessions, by landing page
SELECT
	sessions_w_landing_page_lander1.landing_page,
    COUNT(DISTINCT sessions_w_landing_page_lander1.website_session_id) AS total_sessions,
    COUNT(DISTINCT bounced_sessions_lander1.website_session_id) AS bounced_sessions,
    COUNT(DISTINCT bounced_sessions_lander1.website_session_id) / COUNT(DISTINCT sessions_w_landing_page_lander1.website_session_id) AS bounce_rate
FROM sessions_w_landing_page_lander1
	LEFT JOIN bounced_sessions_lander1
		ON sessions_w_landing_page_lander1.website_session_id = bounced_sessions_lander1.website_session_id
GROUP BY
	sessions_w_landing_page_lander1.landing_page;
    