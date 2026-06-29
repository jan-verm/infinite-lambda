{{ config(
    materialized='table',
    tags=[],
    enabled = true
    ) 
}}

with latest_sales as (
  select pharma, cip, sales_avg_6m
  from {{ ref('int__sales_rolling_avg') }}
  where mo = DATETIME(FORMAT_DATETIME('%Y-%m-01', CURRENT_DATETIME()))
  and sales_avg_6m > 0
)

, stocks as (
  select pharma, cip, stocks
  from {{ ref('int__stock_on_hand') }}
)

, prod_meta as (
  select
    p_pharmacy as pharma,
    cip,
    ean13 as ean,
    name,
    weighted_avg_cost,
    selling_price,
    reimbursement_label
  from {{ ref('stg__product_info') }} pi
  left join {{ ref('seed__vignette_mapping') }} vm on pi.reimb_code = vm.reimb_code
)

, consolidation as (
  select
    p.pharma,
    p.cip as cip,
    p.stocks as stocks,
    r.sales_avg_6m as sales
  from latest_sales r
  full outer join stocks p on r.cip = p.cip and r.pharma = p.pharma
  where r.sales_avg_6m > 0 and p.stocks != 0
)

select
  c.pharma,
  c.cip,
  pm.ean,
  pm.name,
  c.stocks,
  c.sales,
  c.stocks/c.sales as runway,
  pm.weighted_avg_cost,
  pm.selling_price,
  pm.reimbursement_label
from consolidation c
left join prod_meta as pm on pm.pharma = c.pharma and pm.cip = c.cip
order by c.sales desc
