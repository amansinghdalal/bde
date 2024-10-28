WITH source AS (
    SELECT * FROM {{ ref('lga') }}
)

SELECT 
	LGA_CODE as lga_code,
	LGA_NAME as lga_name
		FROM source
