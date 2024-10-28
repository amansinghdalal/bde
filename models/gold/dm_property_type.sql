WITH table_1 AS(
    SELECT
   		PROPERTY_TYPE,
        ROOM_TYPE,
        ACCOMMODATES,
        TO_CHAR(updated_at, 'MM-YYYY') AS MONTH_YEAR,
        COUNT(CASE WHEN has_availability = TRUE THEN 1 END) AS ACTIVE_LISTINGS_COUNT,
        COUNT(CASE WHEN has_availability = FALSE THEN 1 END) AS INACTIVE_LISTINGS_COUNT,
        (COUNT(CASE WHEN has_availability = TRUE THEN 1 END)::FLOAT / COUNT(*)::FLOAT) * 100 AS ACTIVE_LISTINGS_RATE,
        COUNT(DISTINCT host_id) AS DISTINCT_HOSTS_COUNT,
    	(COUNT(DISTINCT CASE WHEN is_superhost = TRUE THEN host_id END)::FLOAT / COUNT(DISTINCT host_id)::FLOAT) * 100 AS SUPERHOST_RATE,
    	AVG(overall_rating) AS avg_review_scores_rating_for_active_listings,
    	SUM(30 - availability_next_30_days) AS total_number_of_stays,
    	AVG(CASE WHEN has_availability = TRUE THEN price END) AS AVERAGE_PRICE
            FROM {{ ref('fact_listings') }}
                GROUP BY PROPERTY_TYPE, ROOM_TYPE, ACCOMMODATES, MONTH_YEAR
),
table_2 AS(
    SELECT 
    	*,
        CASE 
        	WHEN substring(MONTH_YEAR, 0, 3) = '01' THEN NULL
        	ELSE LAG(active_listings_count) OVER (ORDER BY PROPERTY_TYPE, ROOM_TYPE, ACCOMMODATES, MONTH_YEAR) 
        END AS PREVIOUS_MONTH_ACTIVE_LISTINGS,
        CASE 
        	WHEN substring(MONTH_YEAR, 0, 3) = '01' then NULL
        	ELSE LAG(inactive_listings_count) OVER (ORDER BY PROPERTY_TYPE, ROOM_TYPE, ACCOMMODATES, MONTH_YEAR) 
        END AS PREVIOUS_MONTH_INACTIVE_LISTINGS
            FROM table_1
            	ORDER BY PROPERTY_TYPE, ROOM_TYPE, ACCOMMODATES, MONTH_YEAR
)
SELECT
	PROPERTY_TYPE,
	ROOM_TYPE,
	ACCOMMODATES,
	MONTH_YEAR
    MONTH_YEAR,
    ACTIVE_LISTINGS_RATE,
    AVERAGE_PRICE,
    DISTINCT_HOSTS_COUNT,
    SUPERHOST_RATE,
    AVG_REVIEW_SCORES_RATING_FOR_ACTIVE_LISTINGS,
    CASE
        WHEN ACTIVE_LISTINGS_COUNT = 0 THEN 0
        ELSE ACTIVE_LISTINGS_COUNT-PREVIOUS_MONTH_ACTIVE_LISTINGS::float/ACTIVE_LISTINGS_COUNT::float * 100
    END AS PERCENTAGE_CHANGE_ACTIVE,
    CASE
        WHEN INACTIVE_LISTINGS_COUNT = 0 THEN 0
        ELSE INACTIVE_LISTINGS_COUNT-PREVIOUS_MONTH_INACTIVE_LISTINGS::float/INACTIVE_LISTINGS_COUNT::float * 100
    END AS PERCENTAGE_CHANGE_INACTIVE,
    TOTAL_NUMBER_OF_STAYS,
    CASE
        WHEN ACTIVE_LISTINGS_COUNT = 0 THEN NULL
        ELSE TOTAL_NUMBER_OF_STAYS * AVERAGE_PRICE::float / ACTIVE_LISTINGS_COUNT::float
    END AS ESTIMATED_REVENUE_PER_ACTIVE_LISTING
        FROM table_2
            ORDER BY PROPERTY_TYPE, ROOM_TYPE, ACCOMMODATES, MONTH_YEAR
