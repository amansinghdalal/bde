{% macro safe_date_func() %}
CREATE OR REPLACE FUNCTION bronze.safe_date(input_date TEXT, format TEXT)
RETURNS DATE AS $$
BEGIN
    RETURN TO_DATE(input_date, format);
EXCEPTION WHEN OTHERS THEN
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;
{% endmacro %}