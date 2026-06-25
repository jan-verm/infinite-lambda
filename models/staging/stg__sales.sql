{{ config(
    materialized='table',
    tags=[],
    enabled = true
    ) 
}}

with demo_raw_data as (
  select *
  from {{ source('raw', 'stprod') }} stp
  where p_ingestion_dt > '2026-06-20' -- limit for demo purposes
),

latest_ingestion as (
  select p_pharmacy, max(p_ingestion_dt) as p_ingestion_dt
  from demo_raw_data rot
  group by p_pharmacy
)

select rot.* 
from latest_ingestion li
inner join demo_raw_data rot 
on rot.p_pharmacy = li.p_pharmacy and rot.p_ingestion_dt = li.p_ingestion_dt
