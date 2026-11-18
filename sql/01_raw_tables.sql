CREATE TABLE IF NOT EXISTS raw.load_journal (
    log_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    file_name text NOT NULL,
    hash_sum text NOT NULL,
    rows_num bigint NOT NULL,
    time_loaded timestamptz NOT NULL DEFAULT clock_timestamp(),
    UNIQUE (file_name, hash_sum)    
);
CREATE TABLE IF NOT EXISTS raw.orders (
    order_id text,
    customer_id text,
    order_status text,
    order_purchase_timestamp text,
    order_approved_at text,
    order_delivered_carrier_date text,
    order_delivered_customer_date text,
    order_estimated_delivery_date text,
    log_id bigint NOT NULL REFERENCES raw.load_journal (log_id)
);
CREATE TABLE IF NOT EXISTS raw.customers (
    customer_id text,
    customer_unique_id text,
    customer_zip_code_prefix text,
    customer_city text,
    customer_state text,
    log_id bigint NOT NULL REFERENCES raw.load_journal (log_id)
);
CREATE TABLE IF NOT EXISTS raw.order_items (
    order_id text,
    order_item_id text,
    product_id text,
    seller_id text,
    shipping_limit_date text,
    price text,
    freight_value text,
    log_id bigint NOT NULL REFERENCES raw.load_journal (log_id)
);
CREATE TABLE IF NOT EXISTS raw.order_payments (
    order_id text,
    payment_sequential text,
    payment_type text,
    payment_installments text,
    payment_value text,
    log_id bigint NOT NULL REFERENCES raw.load_journal (log_id)
);
CREATE TABLE IF NOT EXISTS raw.products (
    product_id text,
    product_category_name text,
    product_name_lenght text,
    product_description_lenght text,
    product_photos_qty text,
    product_weight_g text,
    product_length_cm text,
    product_height_cm text,
    product_width_cm text,
    log_id bigint NOT NULL REFERENCES raw.load_journal (log_id)
);
