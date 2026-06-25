{{ config(
    materialized='table',
    tags=[],
    enabled = true
    ) 
}}

with latest_sales as (
  select pharma, cip, sales_avg_12m, sales_avg_24m
  from {{ ref('sales_monthly') }}
  where mo = DATETIME(FORMAT_DATETIME('%Y-%m-01', CURRENT_DATETIME()))
)

, product as (
  select 
  p.cip, 
  p.ean13 as ean, 
  p.nom, 
  p.prix_public as pv,
  p.moyenprixaht as prmp,
  p.Code_rembt as code_rembt,
  p.en_stock as stocks,
  p.p_pharmacy as pharma
  from {{ ref('stg__product') }} p
)

, prod_meta as (
  select
    pharma,
    cip,
    ean,
    nom,
    code_rembt,
    prmp,
    pv,
  from product
)

, mapped_consolidation as (
  select
    p.pharma,
    p.cip as cip,
    sum(p.stocks) as stocks,
    sum(cast(r.sales_avg_12m as int64)) as sales
  from latest_sales r
  full outer join product p on r.cip = p.cip and r.pharma = p.pharma
  where r.sales_avg_24m > 0 or p.stocks != 0
  group by 1,2
)

select
  mc.pharma,
  mc.cip,
  pm.ean,
  pm.nom,
  mc.stocks,
  mc.sales,
  pm.prmp,
  pm.pv,
  vm.vignette
from mapped_consolidation mc
left join prod_meta as pm on pm.pharma = mc.pharma and pm.cip = mc.cip
left join {{ ref('seed__vignette_mapping') }} vm on pm.code_rembt = vm.code_rembt
order by mc.sales desc
