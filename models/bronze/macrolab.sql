{{ config(materialized='table') }}

with src as (
  select *
  from {{ source('snowflake','MACRO_LAB') }}
)
select
  s.effective_to,
  {{ effective_to_yyyy_dd_mm('s.effective_to') }} as effective_to_yyyy_dd_mm
from src as s
