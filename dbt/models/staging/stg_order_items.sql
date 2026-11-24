WITH ranked_source AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY order_id, order_item_id ORDER BY log_id DESC) AS rn
    FROM {{ source('raw', 'order_items') }}
)
SELECT order_id,
       order_item_id::INTEGER AS order_item_id,
       product_id,
       seller_id,
       shipping_limit_date::TIMESTAMP AS shipping_limit_date,
       price::NUMERIC AS price,
       freight_value::NUMERIC AS freight_value
  FROM ranked_source
 WHERE rn = 1
