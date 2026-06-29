{{ config(
    materialized='table',
    tags=[],
    enabled = true
    )
}}

select
  p_pharmacy as pharma,
  cip,
  en_stock as stocks
from {{ ref('stg__stock_levels') }}
where en_stock > 0
