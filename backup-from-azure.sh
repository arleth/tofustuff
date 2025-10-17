#!/bin/bash
# Backup VelPharma Database from Azure Production
# This script exports data from the Azure production database
# Usage: ./backup-from-azure.sh [--data-only]

set -e

DATA_ONLY=false
if [ "$1" == "--data-only" ]; then
    DATA_ONLY=true
fi

# Azure database connection details
AZURE_HOST="velp-dev-dbserver.postgres.database.azure.com"
AZURE_PORT="5432"
AZURE_USER="velpharma"
AZURE_DB="velpdevdb"
AZURE_SCHEMA="vpv4"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}VelPharma Azure Production Backup${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Prompt for password
echo -e "${YELLOW}Enter Azure database password:${NC}"
read -s AZURE_PASSWORD
export PGPASSWORD="$AZURE_PASSWORD"
echo ""

# Check if database is running (needed for pg_dump)
if ! docker compose ps postgres | grep -q "Up"; then
    echo -e "${YELLOW}⚠️  Local database not running (needed for pg_dump tool)${NC}"
    echo "Starting local database..."
    docker compose up -d postgres
    echo "Waiting for database to be ready..."
    sleep 5
fi

# Generate timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

if [ "$DATA_ONLY" = true ]; then
    BACKUP_FILE="backups/production_backup_data_only.sql"
    BACKUP_DATED="backups/azure_production_data_only_${TIMESTAMP}.sql"

    echo -e "${GREEN}📦 Exporting DATA-ONLY from Azure...${NC}"
    echo "   Host: $AZURE_HOST"
    echo "   Database: $AZURE_DB"
    echo "   Schema: $AZURE_SCHEMA"
    echo "   Type: Data only (no schema)"
    echo ""

    START_TIME=$(date +%s)
    docker compose exec -T -e PGPASSWORD="$AZURE_PASSWORD" postgres \
        pg_dump -h "$AZURE_HOST" -p "$AZURE_PORT" -U "$AZURE_USER" -d "$AZURE_DB" \
        --data-only --no-owner --no-privileges --schema="$AZURE_SCHEMA" \
        2>/dev/null > "$BACKUP_DATED"
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))

    # Copy to production backup location
    cp "$BACKUP_DATED" "$BACKUP_FILE"

    echo -e "${GREEN}✅ Azure export complete in ${DURATION}s${NC}"
else
    BACKUP_FILE="backups/azure_production_full_${TIMESTAMP}.sql"

    echo -e "${GREEN}📦 Exporting FULL backup from Azure...${NC}"
    echo "   Host: $AZURE_HOST"
    echo "   Database: $AZURE_DB"
    echo "   Schema: $AZURE_SCHEMA"
    echo "   Type: Full (schema + data)"
    echo ""

    START_TIME=$(date +%s)
    docker compose exec -T -e PGPASSWORD="$AZURE_PASSWORD" postgres \
        pg_dump -h "$AZURE_HOST" -p "$AZURE_PORT" -U "$AZURE_USER" -d "$AZURE_DB" \
        --no-owner --no-privileges --schema="$AZURE_SCHEMA" \
        2>/dev/null > "$BACKUP_FILE"
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))

    echo -e "${GREEN}✅ Azure export complete in ${DURATION}s${NC}"
fi

# Check if backup was created successfully
if [ ! -f "$BACKUP_FILE" ]; then
    echo -e "${YELLOW}❌ Backup failed!${NC}"
    exit 1
fi

# Get backup size
SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
LINES=$(wc -l < "$BACKUP_FILE")

echo ""
echo -e "${BLUE}📊 Backup Details:${NC}"
echo "   File: $BACKUP_FILE"
echo "   Size: $SIZE"
echo "   Lines: $LINES"
echo ""

# Show what tables are included
echo -e "${BLUE}📋 Tables Included:${NC}"
grep "Data for Name:" "$BACKUP_FILE" | sed 's/-- Data for Name: /   ✓ /' | sed 's/; Type:.*//'
echo ""

if [ "$DATA_ONLY" = true ]; then
    echo -e "${GREEN}✅ Data-only backup set as current production backup${NC}"
    echo ""
    echo -e "${BLUE}📝 Next Steps:${NC}"
    echo "   1. Test backup: ./reset-db.sh"
    echo "   2. Share backups/ folder with team"
    echo "   3. Team members run: ./reset-db.sh (auto-loads data)"
    echo "   4. Commit to Git: git add backups/production_backup_data_only.sql"
else
    echo -e "${BLUE}💡 Recommendation:${NC}"
    echo "   For faster team onboarding, create data-only backup:"
    echo "   ./backup-from-azure.sh --data-only"
fi

echo ""
echo -e "${BLUE}============================================${NC}"
echo -e "${GREEN}🎉 Azure Backup Complete!${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Clear password
unset PGPASSWORD
