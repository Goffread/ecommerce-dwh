WITH orders AS (
    SELECT order_id,
           customer_id,
           order_status,
           order_purchase_timestamp,
           order_approved_at,
           order_delivered_carrier_date,
           order_delivered_customer_date,
           order_estimated_delivery_date
      FROM {{ ref('stg_orders') }}
), order_items_agg AS (
    SELECT order_id, 
           COUNT(order_item_id) AS count_order_item,
           SUM(price) + SUM(freight_value) AS order_price
      FROM {{ ref('stg_order_items') }}
     GROUP BY order_id
), sum_order_payments AS (
    SELECT order_id,
           SUM(payment_value) AS payment_total
      FROM {{ ref('stg_order_payments') }}
     GROUP BY order_id
)
SELECT o.*,
       oia.count_order_item,
       oia.order_price,
       sop.payment_total
  FROM orders AS o
  LEFT JOIN order_items_agg AS oia USING(order_id)
  LEFT JOIN sum_order_payments AS sop USING(order_id)
