{{ config(
    materialized='incremental',
    incremental_strategy = 'merge',
    unique_key = ['p_pharmacy', 'cip'],
    tags=[],
    enabled = true
    ) 
}}

with raw_data as (
  select *
  from {{ source('raw', 'produit') }} stp
  where p_ingestion_dt > '2026-06-20' -- limit for demo purposes        
  {% if is_incremental() %}
      AND p_ingestion_dt >= FORMAT_DATE('%Y-%m-%d', DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
  {% endif %}
),

deduped_products as (
    SELECT *
    FROM (
        SELECT
            *
            , ROW_NUMBER() OVER (PARTITION BY p_pharmacy, cip ORDER BY p_ingestion_dt DESC) AS row_num
        FROM raw_data
    ) AS deduplicated_orders
    WHERE row_num = 1
)

select 
  p_pharmacy,
  cip,
  en_stock,
  p_ingestion_dt
from deduped_products
