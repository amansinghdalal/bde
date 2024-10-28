{% snapshot reviews_snapshot %}

{{
    config(
        target_schema='bronze',
		    unique_key="listing_id||'-'||host_id",

        strategy='timestamp',
        updated_at='scraped_date'
    )
}}

SELECT 
    LISTING_ID,
    HOST_ID,
    SCRAPED_DATE,
    NUMBER_OF_REVIEWS AS REVIEW_COUNT,
    REVIEW_SCORES_RATING AS OVERALL_RATING,
    REVIEW_SCORES_ACCURACY AS ACCURACY_RATING,
    REVIEW_SCORES_CLEANLINESS AS CLEANLINESS_RATING,
    REVIEW_SCORES_CHECKIN AS CHECKIN_RATING,
    REVIEW_SCORES_COMMUNICATION AS COMMUNICATION_RATING,
    REVIEW_SCORES_VALUE AS VALUE_RATING
        FROM {{ source('raw', 'listings') }}

{% endsnapshot %}