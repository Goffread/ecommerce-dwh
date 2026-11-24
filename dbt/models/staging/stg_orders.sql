WITH ranked_source AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY log_id DESC) AS rn
    FROM {{ source('raw', 'orders') }}
)
SELECT order_id,
       customer_id,
       order_status,
       order_purchase_timestamp::TIMESTAMP AS order_purchase_timestamp,
       order_approved_at::TIMESTAMP AS order_approved_at,
       order_delivered_carrier_date::TIMESTAMP AS order_delivered_carrier_date,
       order_delivered_customer_date::TIMESTAMP AS order_delivered_customer_date,
       order_estimated_delivery_date::TIMESTAMP AS order_estimated_delivery_date
  FROM ranked_source
 WHERE rn = 1
