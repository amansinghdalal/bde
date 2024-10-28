{% snapshot property_snapshot %}

{{
    config(
        target_schema='bronze',
		unique_key="listing_id",

        strategy='timestamp',
        updated_at='scraped_date'
    )
}}

SELECT 
    LISTING_ID,
    SCRAPED_DATE,
    LISTING_NEIGHBOURHOOD,
    PROPERTY_TYPE,
    ROOM_TYPE,
    ACCOMMODATES,
    PRICE,
    HAS_AVAILABILITY,
    AVAILABILITY_30 AS AVAILABILITY_NEXT_30_DAYS,
    NUMBER_OF_REVIEWS AS REVIEW_COUNT,
    REVIEW_SCORES_RATING AS OVERALL_RATING
    	FROM {{ source('raw', 'listings') }}

{% endsnapshot %}