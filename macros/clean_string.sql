{% macro cleanstring(value, case = 'none') %}
    
    {% set core = "REGEXP_REPLACE(TRIM(" ~ value ~ "), '\\\\s+', ' ')" -%})) %}
    {% if case|lower == "upper" %}
        UPPER({{core}})
    {% elif | lower == "lower" %}
        lower({{core}})
    {% else %}
        {{ core }}        
    {% endif %}
{% endmacro %}