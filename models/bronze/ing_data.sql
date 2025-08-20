{{
    config(
        materialized='table'
    )
}}

select * 
from {{ source('snowflake', 'DBT_RAW_DATA') }}