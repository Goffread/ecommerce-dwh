WITH oi AS (
    SELECT order_id,
           order_item_id,
           product_id,
           price,
           freight_value
      FROM {{ ref('stg_order_items') }}
), o AS (
    SELECT order_id,
           customer_id,
           order_status,
           order_purchase_timestamp
      FROM {{ ref('stg_orders') }}
)
SELECT oi.order_id,
       oi.order_item_id,
       oi.product_id,
       oi.price,
       oi.freight_value,
       o.customer_id,
       o.order_status,
       o.order_purchase_timestamp
  FROM oi LEFT JOIN o USING(order_id)
