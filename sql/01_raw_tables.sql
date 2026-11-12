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
