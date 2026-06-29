{{ config(
    materialized='table',
    tags=[],
    enabled = true
    ) 
}}

select 
  pharma,
  cip,
  stocks
from {{ ref('int__stock_on_hand') }}
