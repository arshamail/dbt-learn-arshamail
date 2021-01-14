-- Things to figure out:
-- trailing comma at the end
-- select distinct payment method somehow
-- whitespace clean up

{%- set payment_methods = dot_utils.get_column_values(table=ref{'stg_payment'}, column='payment_method'%}
with
payments as (
    select * from {{ ref('stg_payment') }}
),
pivoted as (
    select 
        order_id,
        {%- for payment_method in ['bank_transfer','coupon','credit_card','gift_card'] %}
        sum(case when payment_method = '{{ payment_method }}' then amount else 0 end) as {{ payment_method }}_amount
        {%- if not loop.last %}, {% endif %}
        {%- endfor %}
    from payments
    group by 1
)
select * from pivoted