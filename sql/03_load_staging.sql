-- Загрузка 10 CSV-файлов (по 1000 строк). staging_id заполняется автоматически.
COPY staging.mock_data (
    id, customer_first_name, customer_last_name, customer_age, customer_email,
    customer_country, customer_postal_code, customer_pet_type, customer_pet_name,
    customer_pet_breed, seller_first_name, seller_last_name, seller_email,
    seller_country, seller_postal_code, product_name, product_category,
    product_price, product_quantity, sale_date, sale_customer_id, sale_seller_id,
    sale_product_id, sale_quantity, sale_total_price, store_name, store_location,
    store_city, store_state, store_country, store_phone, store_email, pet_category,
    product_weight, product_color, product_size, product_brand, product_material,
    product_description, product_rating, product_reviews, product_release_date,
    product_expiry_date, supplier_name, supplier_contact, supplier_email,
    supplier_phone, supplier_address, supplier_city, supplier_country
) FROM '/data/mock_data_1.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

COPY staging.mock_data (
    id, customer_first_name, customer_last_name, customer_age, customer_email,
    customer_country, customer_postal_code, customer_pet_type, customer_pet_name,
    customer_pet_breed, seller_first_name, seller_last_name, seller_email,
    seller_country, seller_postal_code, product_name, product_category,
    product_price, product_quantity, sale_date, sale_customer_id, sale_seller_id,
    sale_product_id, sale_quantity, sale_total_price, store_name, store_location,
    store_city, store_state, store_country, store_phone, store_email, pet_category,
    product_weight, product_color, product_size, product_brand, product_material,
    product_description, product_rating, product_reviews, product_release_date,
    product_expiry_date, supplier_name, supplier_contact, supplier_email,
    supplier_phone, supplier_address, supplier_city, supplier_country
) FROM '/data/mock_data_2.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

COPY staging.mock_data (
    id, customer_first_name, customer_last_name, customer_age, customer_email,
    customer_country, customer_postal_code, customer_pet_type, customer_pet_name,
    customer_pet_breed, seller_first_name, seller_last_name, seller_email,
    seller_country, seller_postal_code, product_name, product_category,
    product_price, product_quantity, sale_date, sale_customer_id, sale_seller_id,
    sale_product_id, sale_quantity, sale_total_price, store_name, store_location,
    store_city, store_state, store_country, store_phone, store_email, pet_category,
    product_weight, product_color, product_size, product_brand, product_material,
    product_description, product_rating, product_reviews, product_release_date,
    product_expiry_date, supplier_name, supplier_contact, supplier_email,
    supplier_phone, supplier_address, supplier_city, supplier_country
) FROM '/data/mock_data_3.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

COPY staging.mock_data (
    id, customer_first_name, customer_last_name, customer_age, customer_email,
    customer_country, customer_postal_code, customer_pet_type, customer_pet_name,
    customer_pet_breed, seller_first_name, seller_last_name, seller_email,
    seller_country, seller_postal_code, product_name, product_category,
    product_price, product_quantity, sale_date, sale_customer_id, sale_seller_id,
    sale_product_id, sale_quantity, sale_total_price, store_name, store_location,
    store_city, store_state, store_country, store_phone, store_email, pet_category,
    product_weight, product_color, product_size, product_brand, product_material,
    product_description, product_rating, product_reviews, product_release_date,
    product_expiry_date, supplier_name, supplier_contact, supplier_email,
    supplier_phone, supplier_address, supplier_city, supplier_country
) FROM '/data/mock_data_4.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

COPY staging.mock_data (
    id, customer_first_name, customer_last_name, customer_age, customer_email,
    customer_country, customer_postal_code, customer_pet_type, customer_pet_name,
    customer_pet_breed, seller_first_name, seller_last_name, seller_email,
    seller_country, seller_postal_code, product_name, product_category,
    product_price, product_quantity, sale_date, sale_customer_id, sale_seller_id,
    sale_product_id, sale_quantity, sale_total_price, store_name, store_location,
    store_city, store_state, store_country, store_phone, store_email, pet_category,
    product_weight, product_color, product_size, product_brand, product_material,
    product_description, product_rating, product_reviews, product_release_date,
    product_expiry_date, supplier_name, supplier_contact, supplier_email,
    supplier_phone, supplier_address, supplier_city, supplier_country
) FROM '/data/mock_data_5.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

COPY staging.mock_data (
    id, customer_first_name, customer_last_name, customer_age, customer_email,
    customer_country, customer_postal_code, customer_pet_type, customer_pet_name,
    customer_pet_breed, seller_first_name, seller_last_name, seller_email,
    seller_country, seller_postal_code, product_name, product_category,
    product_price, product_quantity, sale_date, sale_customer_id, sale_seller_id,
    sale_product_id, sale_quantity, sale_total_price, store_name, store_location,
    store_city, store_state, store_country, store_phone, store_email, pet_category,
    product_weight, product_color, product_size, product_brand, product_material,
    product_description, product_rating, product_reviews, product_release_date,
    product_expiry_date, supplier_name, supplier_contact, supplier_email,
    supplier_phone, supplier_address, supplier_city, supplier_country
) FROM '/data/mock_data_6.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

COPY staging.mock_data (
    id, customer_first_name, customer_last_name, customer_age, customer_email,
    customer_country, customer_postal_code, customer_pet_type, customer_pet_name,
    customer_pet_breed, seller_first_name, seller_last_name, seller_email,
    seller_country, seller_postal_code, product_name, product_category,
    product_price, product_quantity, sale_date, sale_customer_id, sale_seller_id,
    sale_product_id, sale_quantity, sale_total_price, store_name, store_location,
    store_city, store_state, store_country, store_phone, store_email, pet_category,
    product_weight, product_color, product_size, product_brand, product_material,
    product_description, product_rating, product_reviews, product_release_date,
    product_expiry_date, supplier_name, supplier_contact, supplier_email,
    supplier_phone, supplier_address, supplier_city, supplier_country
) FROM '/data/mock_data_7.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

COPY staging.mock_data (
    id, customer_first_name, customer_last_name, customer_age, customer_email,
    customer_country, customer_postal_code, customer_pet_type, customer_pet_name,
    customer_pet_breed, seller_first_name, seller_last_name, seller_email,
    seller_country, seller_postal_code, product_name, product_category,
    product_price, product_quantity, sale_date, sale_customer_id, sale_seller_id,
    sale_product_id, sale_quantity, sale_total_price, store_name, store_location,
    store_city, store_state, store_country, store_phone, store_email, pet_category,
    product_weight, product_color, product_size, product_brand, product_material,
    product_description, product_rating, product_reviews, product_release_date,
    product_expiry_date, supplier_name, supplier_contact, supplier_email,
    supplier_phone, supplier_address, supplier_city, supplier_country
) FROM '/data/mock_data_8.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

COPY staging.mock_data (
    id, customer_first_name, customer_last_name, customer_age, customer_email,
    customer_country, customer_postal_code, customer_pet_type, customer_pet_name,
    customer_pet_breed, seller_first_name, seller_last_name, seller_email,
    seller_country, seller_postal_code, product_name, product_category,
    product_price, product_quantity, sale_date, sale_customer_id, sale_seller_id,
    sale_product_id, sale_quantity, sale_total_price, store_name, store_location,
    store_city, store_state, store_country, store_phone, store_email, pet_category,
    product_weight, product_color, product_size, product_brand, product_material,
    product_description, product_rating, product_reviews, product_release_date,
    product_expiry_date, supplier_name, supplier_contact, supplier_email,
    supplier_phone, supplier_address, supplier_city, supplier_country
) FROM '/data/mock_data_9.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

COPY staging.mock_data (
    id, customer_first_name, customer_last_name, customer_age, customer_email,
    customer_country, customer_postal_code, customer_pet_type, customer_pet_name,
    customer_pet_breed, seller_first_name, seller_last_name, seller_email,
    seller_country, seller_postal_code, product_name, product_category,
    product_price, product_quantity, sale_date, sale_customer_id, sale_seller_id,
    sale_product_id, sale_quantity, sale_total_price, store_name, store_location,
    store_city, store_state, store_country, store_phone, store_email, pet_category,
    product_weight, product_color, product_size, product_brand, product_material,
    product_description, product_rating, product_reviews, product_release_date,
    product_expiry_date, supplier_name, supplier_contact, supplier_email,
    supplier_phone, supplier_address, supplier_city, supplier_country
) FROM '/data/mock_data_10.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
