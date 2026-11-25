SELECT COUNT(product_id) AS count_product_id,
       COUNT(DISTINCT product_id) AS count_distinct_product_id
  FROM raw.products;

SELECT COUNT(*) AS count_product_category_name_nulls
  FROM raw.products
 WHERE product_category_name IS NULL;

SELECT COUNT(*) AS count_float_product_weight_g
  FROM raw.products
 WHERE product_weight_g LIKE '%.%';

SELECT COUNT(*) AS count_float_product_length_cm
  FROM raw.products
 WHERE product_length_cm LIKE '%.%';

SELECT COUNT(*) AS count_float_product_height_cm
  FROM raw.products
 WHERE product_height_cm LIKE '%.%';

SELECT COUNT(*) AS count_float_product_width_cm
  FROM raw.products
 WHERE product_width_cm LIKE '%.%';

SELECT COUNT(*) AS count_nulls_product_weight_g
  FROM raw.products
 WHERE product_weight_g IS NULL;

SELECT COUNT(*) AS count_nulls_product_length_cm
  FROM raw.products
 WHERE product_length_cm IS NULL;

SELECT COUNT(*) AS count_nulls_product_height_cm
  FROM raw.products
 WHERE product_height_cm IS NULL;

SELECT COUNT(*) AS count_nulls_product_width_cm
  FROM raw.products
 WHERE product_width_cm IS NULL;

SELECT *
  FROM raw.products
 WHERE product_weight_g = '0';
 