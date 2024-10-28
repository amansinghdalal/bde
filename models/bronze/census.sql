WITH table_1 AS (
    SELECT * FROM {{ source('raw', 'census_g01_nsw_lga_2016') }}
),

table_2 AS (
    SELECT * FROM {{ source('raw', 'census_g02_nsw_lga_2016') }}
)

SELECT table_1.*,
    table_2.Median_mortgage_repay_monthly,
	table_2.Median_age_persons,
    table_2.Median_tot_prsnl_inc_weekly,
    table_2.Median_rent_weekly,
    table_2.Median_tot_fam_inc_weekly,
    table_2.Average_num_psns_per_bedroom,
    table_2.Median_tot_hhd_inc_weekly,
    table_2.Average_household_size
		FROM table_1
			JOIN table_2 
                ON table_1.LGA_CODE = table_2.LGA_CODE