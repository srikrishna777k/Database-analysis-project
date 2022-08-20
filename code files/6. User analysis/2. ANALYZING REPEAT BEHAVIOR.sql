
#2. ANALYZING REPEAT BEHAVIOR
CREATE TEMPORARY TABLE min_first_session
SELECT
	website_session_id,
    is_repeat_session,
    user_id,
    MIN(created_at) as min_first
FROM website_sessions
WHERE created_at BETWEEN '2014-01-01' AND '2014-11-03'
	AND is_repeat_session = 0
GROUP BY user_id
;

CREATE TEMPORARY TABLE min_second_session
SELECT
	website_session_id,
    is_repeat_session,
    user_id,
    MIN(created_at) AS min_second
FROM website_sessions
WHERE created_at BETWEEN '2014-01-01' AND '2014-11-03'
	AND is_repeat_session = 1
GROUP BY user_id
;

SELECT
	AVG(days_first_to_second) AS avg_days_first_to_second,
    MIN(days_first_to_second) AS min_days_first_to_second,
    MAX(days_first_to_second) AS max_days_first_to_second
FROM (
SELECT
	#user_id,
	DATEDIFF(min_second, min_first) AS days_first_to_second
FROM min_first_session
	INNER JOIN min_second_session
		ON min_first_session.user_id = min_second_session.user_id
) AS subquery
;

