
| Model | Grain | Columns |
| fct_order_items | order_id + order_item_id | product_id, price, freight_value + from stg_orders: customer_id, order_status, order_purchase_timestamp |
| fct_orders | order_id | all from stg_orders + count item, sum price and sum freight from stg_order_items + total order payment from stg_order_payments |
| dim_customers | customer_id | all from stg_customers |
| dim_products | product_id | all from stg_products |
