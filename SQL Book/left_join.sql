-- Load data to Table
create table daily_activity (
	user_id int,
	date date,
	activity_cnt int
);

COPY daily_activity (user_id, date, activity_cnt)
FROM '/Users/hkim/Public/daily_activity.csv' 
DELIMITER ',' CSV HEADER;


/*
Question 1: How many users who were active in January 2020 
are still active in February 2020?
*/

-- Answer 1(a): using an Inner Join
SELECT
    COUNT(*) as users_active_both_months
FROM (
    SELECT DISTINCT
        user_id
    FROM daily_activity
    WHERE date BETWEEN '2020-01-01' AND '2020-01-31'
) as jan
INNER JOIN (
    SELECT DISTINCT
        user_id
    FROM daily_activity
    WHERE date BETWEEN '2020-02-01' AND '2020-02-29'
) as feb
ON jan.user_id = feb.user_id
;

-- Answer 1(b): using a Left Join
SELECT
    COUNT(jan.user_id) as users_active_in_january,
    COUNT(feb.user_id) as users_active_both_months
FROM (
    SELECT DISTINCT
        user_id
    FROM daily_activity
    WHERE date BETWEEN '2020-01-01' AND '2020-01-31'
) as jan
LEFT JOIN (
    SELECT DISTINCT
        user_id
    FROM daily_activity
    WHERE date BETWEEN '2020-02-01' AND '2020-02-29'
) as feb
ON jan.user_id = feb.user_id
;


/*
Question 2: How many % of users who were active in a given 
month are not active in the next month?
*/

-- Answer 2: using a Left Join
SELECT
    COUNT(jan.*) as users_active_in_january,
    COUNT(CASE WHEN feb.user_id is null THEN jan.user_id 
          ELSE null END) as users_not_active_in_february,
    COUNT(CASE WHEN feb.user_id is null THEN jan.user_id 
          ELSE null END)*1.000/COUNT(jan.*) 
      as percent_user_active_in_january_not_in_february
FROM (
    SELECT DISTINCT
        user_id
    FROM daily_activity
    WHERE date BETWEEN '2020-01-01' and '2020-01-31'
) as jan
LEFT JOIN (
    SELECT DISTINCT
        user_id
    FROM daily_activity
    WHERE date BETWEEN '2020-02-01' and '2020-02-29'
) as feb
ON jan.user_id = feb.user_id
;
