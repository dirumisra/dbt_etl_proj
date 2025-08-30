{{
    config(
        materialized='table'
    )
}}

select {{cleanstring ('address_raw') }} from {{ ref('ing_data') }}