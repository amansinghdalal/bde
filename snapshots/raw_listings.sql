{% snapshot listings_snapshot %}

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
      SCRAPE_ID,
      SCRAPED_DATE,
      HOST_ID,
      HOST_NAME,
      CASE 
        WHEN bronze.safe_date(HOST_SINCE, 'DD-MM-YYYY') IS NOT NULL THEN bronze.safe_date(HOST_SINCE, 'DD-MM-YYYY')
        ELSE NULL 
      END AS HOST_SINCE,
      HOST_IS_SUPERHOST,
      HOST_NEIGHBOURHOOD,
      LISTING_NEIGHBOURHOOD,
      PROPERTY_TYPE,
      ROOM_TYPE,
      ACCOMMODATES,
      PRICE,
      HAS_AVAILABILITY,
      AVAILABILITY_30,
      NUMBER_OF_REVIEWS,
      REVIEW_SCORES_RATING,
      REVIEW_SCORES_ACCURACY,
      REVIEW_SCORES_CLEANLINESS,
      REVIEW_SCORES_CHECKIN,
      REVIEW_SCORES_COMMUNICATION,
      REVIEW_SCORES_VALUE
        FROM {{ source('raw', 'listings') }}

{% endsnapshot %}