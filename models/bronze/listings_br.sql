WITH source AS (
	SELECT
		LISTING_ID AS LISTING_ID,
		HOST_ID AS HOST_ID,
		SCRAPE_ID AS SCRAPE_ID,
		SCRAPED_DATE AS SCRAPED_DATE,
		LOWER(HOST_NAME) AS HOST_NAME,
		HOST_SINCE,
		CASE 
			WHEN HOST_IS_SUPERHOST = 't' THEN TRUE
			WHEN HOST_IS_SUPERHOST = 'f' THEN FALSE
			ELSE 'False'
		END AS IS_SUPERHOST,
		CASE
			WHEN LOWER(HOST_NEIGHBOURHOOD) = 'nan' THEN 'unknown'
			ELSE LOWER(HOST_NEIGHBOURHOOD)
		END AS HOST_NEIGHBOURHOOD,
		CASE
			WHEN LOWER(LISTING_NEIGHBOURHOOD) = 'nan' THEN 'unknown'
			ELSE LOWER(LISTING_NEIGHBOURHOOD)
		END AS LISTING_NEIGHBOURHOOD,
		LOWER(PROPERTY_TYPE) AS PROPERTY_TYPE,
		LOWER(ROOM_TYPE) AS ROOM_TYPE,
		ACCOMMODATES AS ACCOMMODATES,
		PRICE AS PRICE,
		CASE
			WHEN HAS_AVAILABILITY = 't' THEN TRUE
			WHEN HAS_AVAILABILITY = 'f' THEN FALSE
			ELSE FALSE
		END AS HAS_AVAILABILITY,
		AVAILABILITY_30 AS AVAILABILITY_NEXT_30_DAYS,
		NUMBER_OF_REVIEWS AS REVIEW_COUNT,
		CASE 
			WHEN REVIEW_SCORES_RATING = 'NaN' then 0
			ELSE REVIEW_SCORES_RATING 
		END AS OVERALL_RATING,
		CASE 
			WHEN REVIEW_SCORES_ACCURACY = 'NaN' then 0
			ELSE REVIEW_SCORES_ACCURACY 
		END AS ACCURACY_RATING,
		CASE
			WHEN REVIEW_SCORES_CLEANLINESS = 'NaN' then 0
			ELSE REVIEW_SCORES_CLEANLINESS
		END AS CLEANLINESS_RATING,
		CASE
			WHEN REVIEW_SCORES_CHECKIN = 'NaN' then 0
			ELSE REVIEW_SCORES_CHECKIN
		END AS CHECKIN_RATING,
		CASE
			WHEN REVIEW_SCORES_COMMUNICATION = 'NaN' then 0
			ELSE REVIEW_SCORES_COMMUNICATION
		END AS COMMUNICATION_RATING,
		CASE
			WHEN REVIEW_SCORES_VALUE = 'NaN' then 0
			ELSE REVIEW_SCORES_VALUE
		END AS VALUE_RATING,
		dbt_scd_id AS UPDATE_ID,
		dbt_updated_at AS UPDATED_AT,
		dbt_valid_from as VALID_FROM,
		CASE
			WHEN dbt_valid_to = NULL THEN (SELECT MAX(dbt_valid_to) FROM {{ ref('listings_snapshot') }})
			ELSE dbt_valid_to
		END AS VALID_TO
			FROM {{ ref('listings_snapshot') }}
)

SELECT *
	FROM source