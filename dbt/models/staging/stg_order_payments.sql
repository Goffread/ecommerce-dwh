WITH ranked_source AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY order_id, payment_sequential ORDER BY log_id DESC) AS rn
    FROM {{ source('raw', 'order_payments') }}
)
SELECT order_id,
       payment_sequential::INTEGER AS payment_sequential,
       NULLIF(payment_type, 'not_defined') AS payment_type,
       NULLIF(payment_installments::INTEGER, 0) AS payment_installments,
       payment_value::NUMERIC(10, 2) AS payment_value
  FROM ranked_source
 WHERE rn = 1