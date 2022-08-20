#4. PRODUCT CONVERISON FUNNELS
#STEP 1: select all pageviews for relevant sessions
CREATE TEMPORARY TABLE sessions_seeing_product_pages
SELECT
	website_session_id,
    website_pageview_id,
	pageview_url AS product_page_seen
FROM website_pageviews
WHERE created_at BETWEEN '2013-01-06' AND '2013-04-10'
	AND pageview_url IN ('/the-original-mr-fuzzy', '/the-forever-love-bear')
;

#STEP 2: figure out which pageview urls to look for
SELECT DISTINCT
	website_pageviews.pageview_url
FROM sessions_seeing_product_pages
	LEFT JOIN website_pageviews
		ON sessions_seeing_product_pages.website_session_id = website_pageviews.website_session_id
			AND sessions_seeing_product_pages.website_pageview_id < website_pageviews.website_pageview_id
;

#STEP 3: pull all pageviews and identify the funnel steps
SELECT
	sessions_seeing_product_pages.website_session_id,
    sessions_seeing_product_pages.product_page_seen,
	CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
    CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
    CASE WHEN pageview_url = '/billing-2' THEN 1 ELSE 0 END AS billing_page,
    CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
FROM sessions_seeing_product_pages
	LEFT JOIN website_pageviews
		ON sessions_seeing_product_pages.website_session_id = website_pageviews.website_session_id
			AND sessions_seeing_product_pages.website_pageview_id < website_pageviews.website_pageview_id
ORDER BY
	sessions_seeing_product_pages.website_session_id,
	website_pageviews.created_at
;

#STEP 4: create session level conversion funnel view
CREATE TEMPORARY TABLE session_product_level_made_it_flags
SELECT
	website_session_id,
    CASE
		WHEN product_page_seen = '/the-original-mr-fuzzy' THEN 'mrfuzzy'
		WHEN product_page_seen = '/the-forever-love-bear' THEN 'lovebear'
		ELSE 'uh oh...check logic'
	END AS product_seen,
    SUM(cart_page) AS to_cart,
    SUM(shipping_page) AS to_shipping,
    SUM(billing_page) AS to_billing,
    SUM(thankyou_page) AS to_thankyou
FROM (
SELECT
	sessions_seeing_product_pages.website_session_id,
    sessions_seeing_product_pages.product_page_seen,
	CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
    CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
    CASE WHEN pageview_url = '/billing-2' THEN 1 ELSE 0 END AS billing_page,
    CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
FROM sessions_seeing_product_pages
	LEFT JOIN website_pageviews
		ON sessions_seeing_product_pages.website_session_id = website_pageviews.website_session_id
			AND sessions_seeing_product_pages.website_pageview_id < website_pageviews.website_pageview_id
ORDER BY
	sessions_seeing_product_pages.website_session_id,
	website_pageviews.created_at
) AS funnel_steps
GROUP BY
	website_session_id,
    CASE
		WHEN product_page_seen = '/the-original-mr-fuzzy' THEN 'mrfuzzy'
		WHEN product_page_seen = '/the-forever-love-bear' THEN 'lovebear'
		ELSE 'uh oh...check logic'
	END
;

#STEP 5: aggregate data to assess funnel performance
SELECT
	product_seen,
    COUNT(website_session_id) AS sessions,
    SUM(to_cart) AS to_cart,
    SUM(to_shipping) AS to_shipping,
    SUM(to_billing) AS to_billing,
    SUM(to_thankyou) AS to_thankyou
FROM session_product_level_made_it_flags
GROUP BY 1
;

SELECT
	product_seen,
    SUM(to_cart) /COUNT(website_session_id) AS product_page_click_rt,
    SUM(to_shipping) / SUM(to_cart) AS cart_click_rt,
    SUM(to_billing) / SUM(to_shipping) AS shipping_click_rt,
    SUM(to_thankyou) / SUM(to_billing) AS billing_click_rt
FROM session_product_level_made_it_flags
GROUP BY 1
;

