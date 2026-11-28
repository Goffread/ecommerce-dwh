WITH t1 AS (
SELECT order_id, SUM(price + freight_value) AS t1_order_sum
  FROM staging.stg_order_items
 GROUP BY order_id),
 t2 AS (
SELECT order_id, SUM(payment_value) AS t2_order_sum
  FROM staging.stg_order_payments
 GROUP BY order_id),
 t3 AS (
 SELECT t1.order_id AS order_id,
        ABS(t1_order_sum - t2_order_sum) AS difference
 FROM t1 JOIN t2 ON t1.order_id = t2.order_id 
                AND t1_order_sum <> t2_order_sum
 ORDER BY difference DESC
 LIMIT 20)

SELECT *
  FROM t3 LEFT JOIN staging.stg_order_payments AS sop
  ON t3.order_id = sop.order_id;
