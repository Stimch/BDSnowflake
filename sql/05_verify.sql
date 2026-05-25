-- Проверка результата трансформации
SELECT 'staging.mock_data' AS object_name, COUNT(*) AS row_count FROM staging.mock_data
UNION ALL
SELECT 'dw.fact_sales', COUNT(*) FROM dw.fact_sales
UNION ALL
SELECT 'dw.dim_customer', COUNT(*) FROM dw.dim_customer
UNION ALL
SELECT 'dw.dim_seller', COUNT(*) FROM dw.dim_seller
UNION ALL
SELECT 'dw.dim_product', COUNT(*) FROM dw.dim_product
UNION ALL
SELECT 'dw.dim_store', COUNT(*) FROM dw.dim_store
UNION ALL
SELECT 'dw.dim_supplier', COUNT(*) FROM dw.dim_supplier
UNION ALL
SELECT 'dw.dim_country', COUNT(*) FROM dw.dim_country
UNION ALL
SELECT 'dw.dim_product_category', COUNT(*) FROM dw.dim_product_category
UNION ALL
SELECT 'dw.dim_date', COUNT(*) FROM dw.dim_date;

-- Пример аналитического запроса: выручка по странам магазинов
SELECT
    co.country_name AS store_country,
    ROUND(SUM(f.total_price)::NUMERIC, 2) AS revenue,
    COUNT(*) AS sales_count
FROM dw.fact_sales f
JOIN dw.dim_store s ON s.store_sk = f.store_sk
JOIN dw.dim_country co ON co.country_sk = s.country_sk
GROUP BY co.country_name
ORDER BY revenue DESC
LIMIT 10;
