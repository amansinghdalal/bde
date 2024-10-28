{% snapshot host_snapshot %}

{{
    config(
       	target_schema='bronze',
		unique_key="host_id",

        strategy='timestamp',
        updated_at='scraped_date'
    )
}}

SELECT 
    HOST_ID,
    SCRAPED_DATE,
    HOST_NAME,
    CASE 
      WHEN bronze.safe_date(HOST_SINCE, 'DD-MM-YYYY') IS NOT NULL THEN safe_date(HOST_SINCE, 'DD-MM-YYYY')
      ELSE NULL 
    END AS HOST_SINCE,
    HOST_IS_SUPERHOST AS IS_SUPERHOST,
    HOST_NEIGHBOURHOOD AS NEIGHBOURHOOD
        FROM {{ source('raw', 'listings') }}

{% endsnapshot %}
