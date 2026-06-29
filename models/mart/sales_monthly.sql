{{ config(
    materialized='table',
    tags=[],
    enabled = true
    )
}}

select
  pharma,
  cip,
  mo,
  sales
from {{ ref('int__sales_monthly') }}
