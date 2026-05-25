# BigDataSnowflake

Лабораторная работа №1 — трансформация данных о магазинах товаров для домашних питомцев в аналитическую модель **«снежинка»** (PostgreSQL).

## Цель работы

Исходные денормализованные записи из CSV преобразуются в схему **фактов и измерений** с нормализацией справочников (общая таблица стран, категории товаров, поставщики со ссылкой на страну и т.д.).

### Схема хранилища (`dw`)

| Тип | Таблица | Назначение |
|-----|---------|------------|
| Измерение | `dim_country` | Страны (общий справочник для customer/seller/store/supplier) |
| Измерение | `dim_product_category` | Категория товара + `pet_category` |
| Измерение | `dim_supplier` | Поставщик → `dim_country` |
| Измерение | `dim_customer` | Покупатель → `dim_country` |
| Измерение | `dim_seller` | Продавец → `dim_country` |
| Измерение | `dim_store` | Магазин → `dim_country` |
| Измерение | `dim_date` | Календарь |
| Измерение | `dim_product` | Товар → `dim_product_category`, `dim_supplier` |
| **Факт** | `fact_sales` | Продажи (количество, цена, сумма) |

Исходные данные до трансформации: `staging.mock_data` (10 000 строк).

## Структура репозитория

```
├── data/                    # mock_data_1.csv … mock_data_10.csv (по 1000 строк)
├── исходные данные/         # оригинальные MOCK_DATA*.csv из задания
├── sql/
│   ├── 01_staging.sql       # DDL staging
│   ├── 02_ddl.sql           # DDL модели «снежинка»
│   ├── 03_load_staging.sql  # COPY из CSV
│   ├── 04_dml.sql           # заполнение dw.*
│   ├── 05_verify.sql        # проверочные запросы
│   └── manual/00_analysis.sql
├── docker-compose.yml
└── README.md
```

## Быстрый запуск (Docker) — для проверки

**Требования:** [Docker Desktop](https://www.docker.com/products/docker-desktop/) (или Docker Engine + Compose v2).

```bash
# из корня репозитория
docker compose up -d
```

При первом запуске PostgreSQL автоматически:

1. создаёт `staging.mock_data` и таблицы `dw.*`;
2. загружает 10 CSV из каталога `data/`;
3. выполняет DML и выводит проверочную статистику в лог инициализации.

Проверка, что контейнер готов:

```bash
docker compose ps
docker compose logs postgres | tail -30
```

Подключение к БД:

| Параметр | Значение |
|----------|----------|
| Host | `localhost` |
| Port | `5432` |
| Database | `petshop` |
| User | `lab` |
| Password | `lab` |

Пример запроса из командной строки:

```bash
docker compose exec -T postgres psql -U lab -d petshop < sql/05_verify.sql
```

На Windows (PowerShell):

```powershell
Get-Content sql\05_verify.sql | docker compose exec -T postgres psql -U lab -d petshop
```

### Контейнер сразу останавливается (`Exited`)

```bash
docker compose logs postgres
```

После обновления репозитория пересоздайте БД:

```bash
git pull
docker compose down -v
docker compose up -d
docker compose logs -f postgres
```

В логе должна появиться строка `Lab init completed successfully`.

Ожидаемый результат: `staging.mock_data` и `dw.fact_sales` содержат по **10 000** строк. Измерения (`dim_customer`, `dim_product` и т.д.) — меньше, потому что в каждом CSV идентификаторы 1–1000 повторяются между файлами (это нормальная дедупликация в снежинке).

Остановка и полный сброс (пересоздание БД с нуля):

```bash
docker compose down -v
docker compose up -d
```

> Скрипты в `/docker-entrypoint-initdb.d/` выполняются только при **первом** создании тома данных. После изменения SQL нужен `docker compose down -v` и повторный `up`.

## Ручной запуск (без пересоздания контейнера)

Если контейнер уже работает, скрипты можно выполнить по порядку:

```bash
docker compose exec -T postgres psql -U lab -d petshop -f - < sql/01_staging.sql
# … аналогично 02, 03, 04, 05
```

Или одной командой (Linux/macOS/Git Bash):

```bash
for f in sql/0*.sql; do
  docker compose exec -T postgres psql -U lab -d petshop -v ON_ERROR_STOP=1 -f - < "$f"
done
```

## Подключение через DBeaver

1. New Database Connection → PostgreSQL.
2. Host `localhost`, port `5432`, database `petshop`, user `lab`, password `lab`.
3. Схемы: `staging` (сырые данные), `dw` (звезда/снежинка).

Анализ сырых данных (шаг 6): `sql/manual/00_analysis.sql`.

## Алгоритм лабораторной (соответствие заданию)

1. Форк репозитория — у вас свой fork.
2. SQL-клиент (DBeaver) — по желанию, для просмотра.
3. PostgreSQL — через `docker compose up`.
4.–5. CSV в `data/` и `исходные данные/`, загрузка в `staging.mock_data` (`03_load_staging.sql`).
6. Анализ — `sql/manual/00_analysis.sql`.
7. Сущности: факты продаж; измерения customer, seller, product, store, supplier, date, country, category.
8. DDL — `sql/02_ddl.sql`.
9. DML — `sql/04_dml.sql`.
10. Проверка — `sql/05_verify.sql`.
11.–12. Ссылка на репозиторий лаборанту.

## Проверочные запросы

```sql
-- количество строк
SELECT COUNT(*) FROM staging.mock_data;   -- 10000
SELECT COUNT(*) FROM dw.fact_sales;      -- 10000

-- пример: выручка по стране магазина
SELECT c.country_name, SUM(f.total_price) AS revenue
FROM dw.fact_sales f
JOIN dw.dim_store s ON s.store_sk = f.store_sk
JOIN dw.dim_country c ON c.country_sk = s.country_sk
GROUP BY c.country_name
ORDER BY revenue DESC;
```

## Автор

Укажите здесь ФИО и группу перед отправкой на проверку.
