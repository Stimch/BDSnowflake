-- Заполнение измерений и фактов из staging.mock_data (модель «снежинка»)

-- 1. Страны (из всех ролей в источнике)
INSERT INTO dw.dim_country (country_name)
SELECT DISTINCT country_name
FROM (
    SELECT NULLIF(TRIM(customer_country), '') AS country_name FROM staging.mock_data
    UNION
    SELECT NULLIF(TRIM(seller_country), '') FROM staging.mock_data
    UNION
    SELECT NULLIF(TRIM(store_country), '') FROM staging.mock_data
    UNION
    SELECT NULLIF(TRIM(supplier_country), '') FROM staging.mock_data
) AS c
WHERE country_name IS NOT NULL
ON CONFLICT (country_name) DO NOTHING;

-- Заглушка для пустых country (редкие строки без страны)
INSERT INTO dw.dim_country (country_name)
VALUES ('Unknown')
ON CONFLICT (country_name) DO NOTHING;

-- 2. Календарь
INSERT INTO dw.dim_date (date_sk, full_date, year, quarter, month, day, day_of_week, month_name)
SELECT
    (EXTRACT(YEAR FROM sale_date)::INT * 10000
        + EXTRACT(MONTH FROM sale_date)::INT * 100
        + EXTRACT(DAY FROM sale_date)::INT) AS date_sk,
    sale_date,
    EXTRACT(YEAR FROM sale_date)::SMALLINT,
    EXTRACT(QUARTER FROM sale_date)::SMALLINT,
    EXTRACT(MONTH FROM sale_date)::SMALLINT,
    EXTRACT(DAY FROM sale_date)::SMALLINT,
    EXTRACT(DOW FROM sale_date)::SMALLINT,
    (ARRAY[
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
    ])[EXTRACT(MONTH FROM sale_date)::INT] AS month_name
FROM staging.mock_data
WHERE sale_date IS NOT NULL
GROUP BY sale_date
ON CONFLICT (full_date) DO NOTHING;

-- 3. Категории товаров
INSERT INTO dw.dim_product_category (product_category, pet_category)
SELECT DISTINCT
    NULLIF(TRIM(product_category), ''),
    COALESCE(NULLIF(TRIM(pet_category), ''), '')
FROM staging.mock_data
WHERE NULLIF(TRIM(product_category), '') IS NOT NULL
ON CONFLICT (product_category, pet_category) DO NOTHING;

-- 4. Поставщики
INSERT INTO dw.dim_supplier (
    supplier_name, supplier_contact, supplier_email, supplier_phone,
    supplier_address, supplier_city, country_sk
)
SELECT DISTINCT ON (s.supplier_name, s.supplier_email)
    s.supplier_name,
    s.supplier_contact,
    s.supplier_email,
    s.supplier_phone,
    s.supplier_address,
    s.supplier_city,
    COALESCE(c.country_sk, u.country_sk)
FROM (
    SELECT
        TRIM(supplier_name) AS supplier_name,
        NULLIF(TRIM(supplier_contact), '') AS supplier_contact,
        NULLIF(TRIM(supplier_email), '') AS supplier_email,
        NULLIF(TRIM(supplier_phone), '') AS supplier_phone,
        NULLIF(TRIM(supplier_address), '') AS supplier_address,
        NULLIF(TRIM(supplier_city), '') AS supplier_city,
        NULLIF(TRIM(supplier_country), '') AS supplier_country
    FROM staging.mock_data
    WHERE NULLIF(TRIM(supplier_name), '') IS NOT NULL
) AS s
LEFT JOIN dw.dim_country c ON c.country_name = s.supplier_country
CROSS JOIN (SELECT country_sk FROM dw.dim_country WHERE country_name = 'Unknown') AS u
ORDER BY s.supplier_name, s.supplier_email, s.supplier_contact
ON CONFLICT (supplier_name, supplier_email) DO NOTHING;

-- 5. Покупатели
INSERT INTO dw.dim_customer (
    customer_id, first_name, last_name, age, email, postal_code,
    pet_type, pet_name, pet_breed, country_sk
)
SELECT DISTINCT ON (sale_customer_id)
    sale_customer_id,
    NULLIF(TRIM(customer_first_name), ''),
    NULLIF(TRIM(customer_last_name), ''),
    customer_age,
    NULLIF(TRIM(customer_email), ''),
    NULLIF(TRIM(customer_postal_code), ''),
    NULLIF(TRIM(customer_pet_type), ''),
    NULLIF(TRIM(customer_pet_name), ''),
    NULLIF(TRIM(customer_pet_breed), ''),
    COALESCE(c.country_sk, u.country_sk)
FROM staging.mock_data m
LEFT JOIN dw.dim_country c ON c.country_name = NULLIF(TRIM(m.customer_country), '')
CROSS JOIN (SELECT country_sk FROM dw.dim_country WHERE country_name = 'Unknown') AS u
ORDER BY sale_customer_id, m.id
ON CONFLICT (customer_id) DO NOTHING;

-- 6. Продавцы
INSERT INTO dw.dim_seller (
    seller_id, first_name, last_name, email, postal_code, country_sk
)
SELECT DISTINCT ON (sale_seller_id)
    sale_seller_id,
    NULLIF(TRIM(seller_first_name), ''),
    NULLIF(TRIM(seller_last_name), ''),
    NULLIF(TRIM(seller_email), ''),
    NULLIF(TRIM(seller_postal_code), ''),
    COALESCE(c.country_sk, u.country_sk)
FROM staging.mock_data m
LEFT JOIN dw.dim_country c ON c.country_name = NULLIF(TRIM(m.seller_country), '')
CROSS JOIN (SELECT country_sk FROM dw.dim_country WHERE country_name = 'Unknown') AS u
ORDER BY sale_seller_id, m.id
ON CONFLICT (seller_id) DO NOTHING;

-- 7. Магазины (префикс m. обязателен: иначе ORDER BY путает колонки с целевой dim_store)
INSERT INTO dw.dim_store (
    store_name, location, city, state, phone, email, country_sk
)
SELECT DISTINCT ON (
    TRIM(m.store_name),
    NULLIF(TRIM(m.store_city), ''),
    NULLIF(TRIM(m.store_location), '')
)
    TRIM(m.store_name),
    NULLIF(TRIM(m.store_location), ''),
    NULLIF(TRIM(m.store_city), ''),
    NULLIF(TRIM(m.store_state), ''),
    NULLIF(TRIM(m.store_phone), ''),
    NULLIF(TRIM(m.store_email), ''),
    COALESCE(c.country_sk, u.country_sk)
FROM staging.mock_data m
LEFT JOIN dw.dim_country c ON c.country_name = NULLIF(TRIM(m.store_country), '')
CROSS JOIN (SELECT country_sk FROM dw.dim_country WHERE country_name = 'Unknown') AS u
WHERE NULLIF(TRIM(m.store_name), '') IS NOT NULL
ORDER BY
    TRIM(m.store_name),
    NULLIF(TRIM(m.store_city), ''),
    NULLIF(TRIM(m.store_location), ''),
    m.id
ON CONFLICT (store_name, city, location) DO NOTHING;

-- 8. Товары
INSERT INTO dw.dim_product (
    product_id, product_name, brand, material, color, size, weight,
    description, rating, reviews, release_date, expiry_date,
    list_price, stock_quantity, category_sk, supplier_sk
)
SELECT DISTINCT ON (sale_product_id)
    sale_product_id,
    TRIM(product_name),
    NULLIF(TRIM(product_brand), ''),
    NULLIF(TRIM(product_material), ''),
    NULLIF(TRIM(product_color), ''),
    NULLIF(TRIM(product_size), ''),
    product_weight,
    NULLIF(TRIM(product_description), ''),
    product_rating,
    product_reviews,
    product_release_date,
    product_expiry_date,
    product_price,
    product_quantity,
    cat.category_sk,
    sup.supplier_sk
FROM staging.mock_data m
JOIN LATERAL (
    SELECT category_sk
    FROM dw.dim_product_category cat
    WHERE cat.product_category = NULLIF(TRIM(m.product_category), '')
      AND cat.pet_category = COALESCE(NULLIF(TRIM(m.pet_category), ''), '')
    LIMIT 1
) cat ON TRUE
JOIN LATERAL (
    SELECT supplier_sk
    FROM dw.dim_supplier sup
    WHERE sup.supplier_name = TRIM(m.supplier_name)
    ORDER BY sup.supplier_sk
    LIMIT 1
) sup ON TRUE
ORDER BY sale_product_id, m.id
ON CONFLICT (product_id) DO NOTHING;

-- 9. Факты продаж
INSERT INTO dw.fact_sales (
    sale_id, date_sk, customer_sk, seller_sk, product_sk, store_sk,
    quantity, unit_price, total_price
)
SELECT
    m.staging_id,
    d.date_sk,
    cust.customer_sk,
    sel.seller_sk,
    prod.product_sk,
    st.store_sk,
    m.sale_quantity,
    m.product_price,
    m.sale_total_price
FROM staging.mock_data m
JOIN dw.dim_date d ON d.full_date = m.sale_date
JOIN dw.dim_customer cust ON cust.customer_id = m.sale_customer_id
JOIN dw.dim_seller sel ON sel.seller_id = m.sale_seller_id
JOIN dw.dim_product prod ON prod.product_id = m.sale_product_id
JOIN dw.dim_store st
    ON st.store_name = TRIM(m.store_name)
   AND st.city IS NOT DISTINCT FROM NULLIF(TRIM(m.store_city), '')
   AND st.location IS NOT DISTINCT FROM NULLIF(TRIM(m.store_location), '')
ON CONFLICT (sale_id) DO NOTHING;
