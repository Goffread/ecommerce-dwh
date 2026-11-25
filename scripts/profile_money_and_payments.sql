SELECT payment_type, COUNT(*)
  FROM raw.order_payments
 GROUP BY payment_type;

SELECT *
  FROM raw.order_payments
 WHERE payment_type = 'not_defined';

SELECT MAX(payment_installments::INTEGER),
       MIN(payment_installments::INTEGER)
  FROM raw.order_payments;

SELECT *
  FROM raw.order_payments
 WHERE payment_installments='0';

SELECT order_id, payment_sequential
  FROM raw.order_payments
GROUP BY order_id, payment_sequential
HAVING COUNT(*) > 1;

SELECT MAX(length(split_part(price, '.', 2))) AS max_float_length_price,
       MAX(length(split_part(price, '.', 1))) AS max_int_length_price,
       MAX(length(split_part(freight_value, '.', 2))) AS max_float_length_freight_value,
       MAX(length(split_part(freight_value, '.', 1))) AS max_int_length_freight_value
  FROM raw.order_items;

SELECT MAX(length(split_part(payment_value, '.', 2))) AS max_float_length_payment_value,
       MAX(length(split_part(payment_value, '.', 1))) AS max_int_length_payment_value
  FROM raw.order_payments;

SELECT COUNT(*) AS minus_count_price_and_freight_value
  FROM raw.order_items
WHERE price LIKE '%-%' or freight_value LIKE '%-%';

SELECT COUNT(*) AS minus_count_payment_value
  FROM raw.order_payments
WHERE payment_value LIKE '%-%';
