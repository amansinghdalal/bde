{% snapshot lga_suburb_snapshot %}

{{
    config(
        target_schema='bronze',
        strategy='check',

        unique_key='LGA_NAME',
        check_cols=['LGA_NAME', 'LGA_SUBURB'],
        )
}}

SELECT * FROM {{ source('raw', 'nsw_lga_suburb') }}

{% endsnapshot %}
