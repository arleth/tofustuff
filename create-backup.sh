#!/bin/bash
# Create VelPharma Database Backup
# This script creates timestamped backups (both full and data-only)
# Usage: ./create-backup.sh [--data-only]

set -e

DATA_ONLY=false
if [ "$1" == "--data-only" ]; then
    DATA_ONLY=true
fi

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}VelPharma Database Backup Creator${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Check if database is running
if ! docker compose ps postgres | grep -q "Up"; then
    echo -e "${YELLOW}⚠️  Database is not running${NC}"
    echo "Starting database..."
    docker compose up -d postgres
    echo "Waiting for database to be ready..."
    sleep 5
fi

# Generate timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

if [ "$DATA_ONLY" = true ]; then
    BACKUP_FILE="backups/production_backup_data_only.sql"
    BACKUP_DATED="backups/production_backup_data_only_${TIMESTAMP}.sql"

    echo -e "${GREEN}📦 Creating DATA-ONLY backup...${NC}"
    echo "   Type: Data only (no schema)"
    echo "   File: $BACKUP_FILE"
    echo ""

    START_TIME=$(date +%s)
    docker compose exec postgres pg_dump -U postgres --data-only --no-owner velpdevdb > "$BACKUP_DATED"
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))

    # Always replace data-only as current
    cp "$BACKUP_DATED" "$BACKUP_FILE"
else
    BACKUP_FILE="backups/production_backup_full_${TIMESTAMP}.sql"
    BACKUP_LINK="backups/production_backup.sql"

    echo -e "${GREEN}📦 Creating FULL backup...${NC}"
    echo "   Type: Full (schema + data)"
    echo "   File: $BACKUP_FILE"
    echo ""

    START_TIME=$(date +%s)
    docker compose exec postgres pg_dump -U postgres velpdevdb > "$BACKUP_FILE"
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))
fi

# Check if backup was created successfully
if [ ! -f "$BACKUP_FILE" ]; then
    echo -e "${YELLOW}❌ Backup failed!${NC}"
    exit 1
fi

# Get backup size
SIZE=$(du -h "$BACKUP_FILE" | cut -f1)

echo -e "${GREEN}✅ Backup created successfully in ${DURATION}s${NC}"
echo "   Size: $SIZE"
echo ""

# Show data counts
echo -e "${BLUE}📊 Backup Contents:${NC}"
docker compose exec postgres psql -U postgres -d velpdevdb -t -c "
SELECT '   Products: ' || COUNT(*) FROM vpv4.PRODUCTS
UNION ALL
SELECT '   ADRs: ' || COUNT(*) FROM vpv4.ADVERSE_DRUG_REACTIONS
UNION ALL
SELECT '   Manufacturers: ' || COUNT(*) FROM vpv4.MANUFACTURERS
UNION ALL
SELECT '   ATC Codes: ' || COUNT(*) FROM vpv4.ATC_CODES;
" 2>/dev/null | grep -v "^$"
echo ""

if [ "$DATA_ONLY" = true ]; then
    echo -e "${GREEN}✅ Data-only backup set as current${NC}"
    echo ""
    echo -e "${BLUE}📝 Next Steps:${NC}"
    echo "   1. Run ./reset-db.sh to test the backup"
    echo "   2. Share backup with team members"
    echo "   3. Team members run: ./reset-db.sh (will auto-load data)"
else
    # Ask if should set full backup as production
    echo -e "${YELLOW}Set this full backup for fallback?${NC}"
    echo "   (Data-only backup is preferred, full is fallback)"
    echo ""
    read -p "Create symlink? [y/N]: " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        ln -sf "production_backup_full_${TIMESTAMP}.sql" "$BACKUP_LINK"
        echo -e "${GREEN}✅ Linked as fallback backup${NC}"
    else
        echo -e "${YELLOW}⏭️  Skipped linking${NC}"
    fi

    echo ""
    echo -e "${BLUE}💡 Recommendation:${NC}"
    echo "   Create data-only backup instead:"
    echo "   ./create-backup.sh --data-only"
fi

echo ""
echo -e "${BLUE}============================================${NC}"
echo -e "${GREEN}🎉 Backup Complete!${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""
echo -e "${BLUE}Backup Location:${NC} $BACKUP_FILE"
echo -e "${BLUE}Backup Size:${NC} $SIZE"
echo ""
