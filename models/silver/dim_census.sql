WITH source AS (
    SELECT * FROM {{ ref('census_br') }}
)

SELECT * 
	FROM source
