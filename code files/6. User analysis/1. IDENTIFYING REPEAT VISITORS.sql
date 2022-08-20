
#1. IDENTIFYING REPEAT VISITORS
create temporary table sessions_w_repeat
select
    new_sessions.user_id,
    new_sessions.website_session_id AS new_session_id,
    website_sessions.website_session_id AS repeat_session_id
from(
select 
    user_id,
    website_session_id
from website_sessions
where created_at between '2014-01-01' AND '2014-11-01'
    and is_repeat_session = 0
) as new_sessions    
    LEFT JOIN website_sessions
        ON website_sessions.user_id = new_sessions.user_id
        AND website_sessions.created_at between '2014-01-01' AND '2014-11-01'
        AND website_sessions.is_repeat_session = 1 -- was a repeat session (redundant but good to illustrate)
        AND website_sessions.website_session_id > new_sessions.website_session_id -- session was later than new session 
;

select
    repeat_sessions,
    count(distinct user_id) as users
from(
select
    user_id,
    COUNT(DISTINCT new_session_id) AS new_sessions,
    COUNT(DISTINCT repeat_session_id) AS repeat_sessions
from sessions_w_repeat
group by 1
order by 3 desc
) as user_level
group by 1;