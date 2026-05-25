-- Примеры аналитических запросов к исходным данным (шаг 6 лабораторной)
-- Запускать после загрузки staging.mock_data

SELECT COUNT(DISTINCT sale_customer_id) AS customers FROM staging.mock_data;
SELECT COUNT(DISTINCT sale_seller_id) AS sellers FROM staging.mock_data;
SELECT COUNT(DISTINCT sale_product_id) AS products FROM staging.mock_data;
SELECT COUNT(DISTINCT store_name) AS stores FROM staging.mock_data;
SELECT COUNT(DISTINCT supplier_name) AS suppliers FROM staging.mock_data;

SELECT MIN(sale_date) AS min_date, MAX(sale_date) AS max_date FROM staging.mock_data;

SELECT
    product_category,
    ROUND(SUM(sale_total_price)::NUMERIC, 2) AS revenue
FROM staging.mock_data
GROUP BY product_category
ORDER BY revenue DESC;
