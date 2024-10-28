{% macro safe_date() %}
CREATE OR REPLACE FUNCTION safe_date(input_date TEXT, format TEXT)
RETURNS DATE AS $$
BEGIN
    RETURN TO_DATE(input_date, format);
EXCEPTION WHEN OTHERS THEN
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;
{% endmacro %}