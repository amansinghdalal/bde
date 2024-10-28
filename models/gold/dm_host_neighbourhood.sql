WITH joined_table AS(
    select
    	table1.lga_name as host_neighbourhood_lga,
    	TO_CHAR(updated_at, 'MM-YYYY') AS MONTH_YEAR,
    	COUNT(DISTINCT host_id) AS DISTINCT_HOSTS_COUNT,
    	SUM(30 - table2.availability_next_30_days) AS total_number_of_stays,
		AVG(CASE WHEN table2.has_availability = TRUE THEN price END) AS AVERAGE_PRICE
        FROM {{ ref('lga') }} table1
        	JOIN {{ ref('fact_listings') }} table2
            	ON table2.host_neighbourhood = table1.lga_suburb
            		group by host_neighbourhood_lga, MONTH_YEAR
)
select
	host_neighbourhood_lga,
	MONTH_YEAR,
	DISTINCT_HOSTS_COUNT,
	total_number_of_stays * AVERAGE_PRICE as estimated_revenue,
	total_number_of_stays * AVERAGE_PRICE :: float / distinct_hosts_count as estimated_revenue_per_host
		from joined_table
			order by host_neighbourhood_lga, month_year
