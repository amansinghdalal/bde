WITH source AS (
    SELECT * FROM {{ ref('census') }}
)

SELECT * 
	FROM source
