{% macro cast_sales_columns(relation_alias='', n_months=30) %}
{%- set prefix = relation_alias ~ '.' if relation_alias else '' -%}
{% for i in range(1, n_months + 1) %}
, cast({{ prefix }}v{{ i }} as int64) as v{{ i }}
{% endfor %}
{% endmacro %}

{% macro unpivot_sales_columns(from_relation, n_months=30) %}
{% for i in range(1, n_months + 1) %}
  select
    pharma,
    DATE_SUB(mo, INTERVAL {{ i - 1 }} MONTH) as mo,
    cip,
    v{{ i }} as sales
  from {{ from_relation }}
  {% if not loop.last %} union all {% endif %}
{% endfor %}
{% endmacro %}
