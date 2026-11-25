WITH ranked_source AS (
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY product_id ORDER BY log_id DESC) AS rn
    FROM {{ source('raw', 'products') }}
)
SELECT product_id,
       product_category_name,
       product_name_lenght::INTEGER AS product_name_length,
       product_description_lenght::INTEGER AS product_description_length,
       product_photos_qty::INTEGER AS product_photos_qty,
       NULLIF(product_weight_g::INTEGER, 0) AS product_weight_g,
       product_length_cm::INTEGER AS product_length_cm,
       product_height_cm::INTEGER AS product_height_cm,
       product_width_cm::INTEGER AS product_width_cm
  FROM ranked_source
 WHERE rn = 1
