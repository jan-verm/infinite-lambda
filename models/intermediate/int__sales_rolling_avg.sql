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
  AVG(sales) OVER(PARTITION BY pharma, cip ORDER BY mo asc ROWS BETWEEN 6 PRECEDING AND 1 PRECEDING) AS sales_avg_6m
from {{ ref('int__sales_monthly') }}
