#!/bin/bash

# Скрипт для применения миграций к Supabase через psql.
# Подключение ожидается через локальный SSH-туннель или другой защищённый канал,
# параметры берутся из .env.supabase.
#
# Использование:
#   ./apply_migration.sh [путь_к_миграции]
#
# Пример:
#   ./apply_migration.sh supabase/migrations/20260608112723_create_mcp_test_migration.sql

set -o pipefail

# Загружаем переменные окружения.
if [ -f .env.supabase ]; then
    set -a
    # shellcheck disable=SC1091
    source .env.supabase
    set +a
fi

# Цвета для вывода.
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Проверяем наличие psql.
if ! command -v psql &> /dev/null; then
    echo -e "${RED}❌ psql не найден. Установите PostgreSQL client.${NC}"
    exit 1
fi

# Проверяем обязательные переменные подключения.
REQUIRED_VARS=(DB_HOST DB_PORT DB_USER DB_PASSWORD DB_NAME)
for VAR_NAME in "${REQUIRED_VARS[@]}"; do
    if [ -z "${!VAR_NAME}" ]; then
        echo -e "${RED}❌ Не задана переменная ${VAR_NAME}. Создайте .env.supabase на основе .env.supabase.example.${NC}"
        exit 1
    fi
done

# Определяем файл миграции.
MIGRATION_FILE="${1:-supabase/migrations/20260608112723_create_mcp_test_migration.sql}"

if [ ! -f "$MIGRATION_FILE" ]; then
    echo -e "${RED}❌ Файл миграции не найден: $MIGRATION_FILE${NC}"
    exit 1
fi

echo -e "${YELLOW}📝 Применяем миграцию: $MIGRATION_FILE${NC}"
echo -e "${YELLOW}🔌 Подключение: ${DB_HOST}:${DB_PORT}/${DB_NAME} user=${DB_USER}${NC}"
echo ""

# Применяем миграцию.
PGPASSWORD="$DB_PASSWORD" psql \
    -h "$DB_HOST" \
    -p "$DB_PORT" \
    -U "$DB_USER" \
    -d "$DB_NAME" \
    -v ON_ERROR_STOP=1 \
    -f "$MIGRATION_FILE"

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ Миграция успешно применена!${NC}"
else
    echo ""
    echo -e "${RED}❌ Ошибка при применении миграции${NC}"
    exit 1
fi