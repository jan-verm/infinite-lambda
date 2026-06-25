{{ config(
    materialized='table',
    tags=[],
    enabled = true
    ) 
}}

with base as (
select
    stp.p_pharmacy as pharma,
    smn.mo,
    stp.cip
    {% for i in range(1, 31) %}
    , cast(stp.v{{ i }} as int64) as v{{ i }}
    {% endfor %}
from {{ ref('stg__sales') }} stp
inner join {{ ref('int__sales_month_numbering') }} smn
    on smn.mo_num = cast(stp.lastmonth as int64)
)

, base_zero_sales as (
  select 
    stp.p_pharmacy as pharma
    , smn.mo
    , stp.cip
  from {{ ref('stg__sales') }} stp
  inner join {{ ref('int__sales_month_numbering') }} smn on smn.mo_num = cast(stp.lastmonth as int64)
  where cast(stp.lastmonth as int64) != (select max(mo_num) from {{ ref('int__sales_month_numbering') }} )
)

, zero_sales as (
  select base.pharma, generated_month as mo, base.cip, 0 as sales
  from base
  cross join unnest(GENERATE_DATE_ARRAY(EXTRACT(DATE FROM base.mo), CURRENT_DATE(), INTERVAL 1 MONTH)) generated_month
  where generated_month > base.mo
  order by generated_month desc
)

, sales_kv as (
  select pharma, mo, cip, sales from zero_sales
  union all 
  {% for i in range(1, 31) %}
  select 
      pharma,
      DATE_SUB(mo, INTERVAL {{ i - 1 }} MONTH) as mo,
      cip,
      v{{ i }} as sales
  from base
    {% if not loop.last %} union all {% endif %}
  {% endfor %}
)

select 
  pharma, 
  mo, 
  cip, 
  sales
from sales_kv
