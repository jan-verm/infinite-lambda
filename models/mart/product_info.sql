{{ config(
    materialized='table',
    tags=[],
    enabled = true
    ) 
}}

select 
  p_pharmacy as pharma,
  cip,
  ean13 as ean,
  reimb_code,
  name,
  selling_price,
  weighted_avg_cost,
  p_ingestion_dt
from {{ ref('stg__product_info') }}
