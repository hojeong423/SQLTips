-- Load data to Table
create table customer_milestone (
	user_id int,
	milestone varchar(20),
	month date
);

COPY customer_milestone (user_id, milestone, month)
FROM '/Users/hkim/Public/customer_milestone.csv' 
DELIMITER ',' CSV HEADER

/*
Case 1:
product customer_milestone_by_milestone
from customer_milestone
*/

CREATE TABLE customer_milestone_by_milestone as (
    SELECT
        user_id,
        MIN(CASE WHEN milestone='First' THEN month ELSE null END) 
            as month_first,
        MIN(CASE WHEN milestone='Milestone_100' THEN month ELSE null END) 
            as month_100,
        MIN(CASE WHEN milestone='Milestone_500' THEN month ELSE null END) 
            as month_500
    FROM customer_milestone
    GROUP BY user_id
);

/*
Case 2: 
reproduct customer_milestone output
from customer_milestone_by_milestone
*/
    SELECT
        user_id,
        cast('First' as varchar(20)) as milestone,
        month_first as month
    FROM customer_milestone_by_milestone
    WHERE month_first is not null

    UNION ALL

    SELECT
        user_id,
        cast('Milestone_100' as varchar(20)) as milestone,
        month_100 as month
    FROM customer_milestone_by_milestone
    WHERE month_100 is not null

    UNION ALL
    
    SELECT
        user_id,
        cast('Milestone_500' as varchar(20)) as milestone,
        month_500 as month
    FROM customer_milestone_by_milestone
    WHERE month_500 is not null
    ;