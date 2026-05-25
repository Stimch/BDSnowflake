#!/bin/bash
set -euo pipefail

# CSV с хоста должны читаться пользователем postgres в контейнере (частая проблема на Linux)
if [ -d /data ]; then
  chmod -R a+rX /data 2>/dev/null || true
fi

run_sql() {
  echo ">> Running $1"
  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -f "$1"
}

for script in /sql/00_config.sql \
              /sql/01_staging.sql \
              /sql/02_ddl.sql \
              /sql/03_load_staging.sql \
              /sql/04_dml.sql \
              /sql/05_verify.sql; do
  run_sql "$script"
done

echo ">> Lab init completed successfully"
