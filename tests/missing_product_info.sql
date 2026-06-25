select *
from {{ ref('stock_levels') }} s
left join {{ ref('product_info') }} pi
  on s.pharma = pi.pharma and s.cip = pi.cip
where pi.cip is null