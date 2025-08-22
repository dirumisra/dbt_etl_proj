{% macro effective_to_yyyy_dd_mm(col_expr) %}
  -- Input: DATE
  -- Output: VARCHAR in YYYY-DD-MM (e.g., 9999-31-12)
  to_varchar({{ col_expr }}::date, 'YYYY-DD-MM')
{% endmacro %}


