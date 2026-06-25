{{ config(
    materialized='table',
    tags=[],
    enabled = true
    ) 
}}

select 
  p_pharmacy as pharma,
  cip,
  en_stock as stock_level,
  p_ingestion_dt
from {{ ref('stg__stock_levels') }}
