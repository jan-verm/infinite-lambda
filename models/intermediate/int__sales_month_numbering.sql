{{ config(
    materialized='table',
    tags=[],
    enabled = true
    ) 
}}

with current_month as (
  select 
  cast(max(lastmonth) as int64) as current_month_num,
  DATETIME(FORMAT_DATETIME('%Y-%m-01', CURRENT_DATETIME())) as current_month,
  from {{ ref('stg__sales') }}
)

, numbering as (
    {% for i in range(0, 36 + 1) %}
      select
          DATE_SUB(c.current_month, INTERVAL {{ i }} MONTH) as mo,
          c.current_month_num - {{ i }} as mo_num
      from current_month c

      {% if not loop.last %}
      union all
      {% endif %}

    {% endfor %}
)

select mo, mo_num from numbering order by mo_num desc
