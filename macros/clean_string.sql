{% macro cleanstring(column) %}
    
    trim({{column}})
        
{% endmacro %}