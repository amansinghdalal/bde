WITH source AS (
    SELECT * FROM {{ ref('lga_br') }}
)

SELECT 
	LGA_CODE as lga_code,
	LGA_NAME as lga_name
		FROM source
