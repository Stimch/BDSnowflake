-- Модель «снежинка»: измерения с нормализацией + таблица фактов
CREATE SCHEMA IF NOT EXISTS dw;

-- Общее измерение стран (нормализация country в customer/seller/store/supplier)
CREATE TABLE dw.dim_country (
    country_sk   SERIAL PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL UNIQUE
);

-- Категория товара + тип питомца для линейки (нормализация product_category / pet_category)
CREATE TABLE dw.dim_product_category (
    category_sk       SERIAL PRIMARY KEY,
    product_category  VARCHAR(100) NOT NULL,
    pet_category      VARCHAR(100) NOT NULL DEFAULT '',
    UNIQUE (product_category, pet_category)
);

-- Поставщик → страна (ветка снежинки)
CREATE TABLE dw.dim_supplier (
    supplier_sk      SERIAL PRIMARY KEY,
    supplier_name    VARCHAR(200) NOT NULL,
    supplier_contact VARCHAR(200),
    supplier_email   VARCHAR(200),
    supplier_phone   VARCHAR(50),
    supplier_address TEXT,
    supplier_city    VARCHAR(100),
    country_sk       INTEGER NOT NULL REFERENCES dw.dim_country (country_sk),
    UNIQUE (supplier_name, supplier_email)
);

-- Покупатель → страна
CREATE TABLE dw.dim_customer (
    customer_sk    SERIAL PRIMARY KEY,
    customer_id    INTEGER NOT NULL UNIQUE,
    first_name     VARCHAR(100),
    last_name      VARCHAR(100),
    age            INTEGER,
    email          VARCHAR(200),
    postal_code    VARCHAR(50),
    pet_type       VARCHAR(50),
    pet_name       VARCHAR(100),
    pet_breed      VARCHAR(100),
    country_sk     INTEGER REFERENCES dw.dim_country (country_sk)
);

-- Продавец → страна
CREATE TABLE dw.dim_seller (
    seller_sk    SERIAL PRIMARY KEY,
    seller_id    INTEGER NOT NULL UNIQUE,
    first_name   VARCHAR(100),
    last_name    VARCHAR(100),
    email        VARCHAR(200),
    postal_code  VARCHAR(50),
    country_sk   INTEGER REFERENCES dw.dim_country (country_sk)
);

-- Магазин → страна
CREATE TABLE dw.dim_store (
    store_sk     SERIAL PRIMARY KEY,
    store_name   VARCHAR(200) NOT NULL,
    location     TEXT,
    city         VARCHAR(100),
    state        VARCHAR(100),
    phone        VARCHAR(50),
    email        VARCHAR(200),
    country_sk   INTEGER REFERENCES dw.dim_country (country_sk),
    UNIQUE (store_name, city, location)
);

-- Календарь
CREATE TABLE dw.dim_date (
    date_sk      INTEGER PRIMARY KEY,
    full_date    DATE NOT NULL UNIQUE,
    year         SMALLINT NOT NULL,
    quarter      SMALLINT NOT NULL,
    month        SMALLINT NOT NULL,
    day          SMALLINT NOT NULL,
    day_of_week  SMALLINT NOT NULL,
    month_name   VARCHAR(20) NOT NULL
);

-- Товар → категория, поставщик (две ветки снежинки)
CREATE TABLE dw.dim_product (
    product_sk        SERIAL PRIMARY KEY,
    product_id        INTEGER NOT NULL UNIQUE,
    product_name      VARCHAR(200) NOT NULL,
    brand             VARCHAR(100),
    material          VARCHAR(100),
    color             VARCHAR(50),
    size              VARCHAR(50),
    weight            NUMERIC(12, 2),
    description       TEXT,
    rating            NUMERIC(4, 2),
    reviews           INTEGER,
    release_date      DATE,
    expiry_date       DATE,
    list_price        NUMERIC(12, 2),
    stock_quantity    INTEGER,
    category_sk       INTEGER NOT NULL REFERENCES dw.dim_product_category (category_sk),
    supplier_sk       INTEGER NOT NULL REFERENCES dw.dim_supplier (supplier_sk)
);

-- Факты продаж
CREATE TABLE dw.fact_sales (
    sale_sk       SERIAL PRIMARY KEY,
    sale_id       INTEGER NOT NULL UNIQUE,
    date_sk       INTEGER NOT NULL REFERENCES dw.dim_date (date_sk),
    customer_sk   INTEGER NOT NULL REFERENCES dw.dim_customer (customer_sk),
    seller_sk     INTEGER NOT NULL REFERENCES dw.dim_seller (seller_sk),
    product_sk    INTEGER NOT NULL REFERENCES dw.dim_product (product_sk),
    store_sk      INTEGER NOT NULL REFERENCES dw.dim_store (store_sk),
    quantity      INTEGER NOT NULL,
    unit_price    NUMERIC(12, 2),
    total_price   NUMERIC(12, 2) NOT NULL
);

CREATE INDEX idx_fact_sales_date ON dw.fact_sales (date_sk);
CREATE INDEX idx_fact_sales_customer ON dw.fact_sales (customer_sk);
CREATE INDEX idx_fact_sales_product ON dw.fact_sales (product_sk);
