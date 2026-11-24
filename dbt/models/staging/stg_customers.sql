WITH ranked_source AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY log_id DESC) AS rn
    FROM {{ source('raw', 'customers') }}
)
SELECT customer_id,
       customer_unique_id,
       customer_zip_code_prefix,
       customer_city,
       customer_state
  FROM ranked_source
 WHERE rn = 1
