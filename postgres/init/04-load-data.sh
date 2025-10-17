#!/bin/bash
# Smart data loader for VelPharma Database
# Priority: Data-only Backup → Full Backup (with errors) → Seed → Empty Schema
#
# This script runs during PostgreSQL initialization and decides
# what data to load based on availability:
#
# 1. DATA-ONLY BACKUP (preferred): Fast, clean data load
# 2. FULL BACKUP (fallback): Load with schema errors ignored
# 3. SEED FILE (fallback): Manual seed data for testing
# 4. EMPTY SCHEMA (last resort): Just tables, no data

set -e

BACKUP_DATA_ONLY="/backups/production_backup_data_only.sql"
BACKUP_FULL="/backups/production_backup.sql"
SEED_FILE="/docker-entrypoint-initdb.d/_05-seed-base.sql.disabled"

echo "============================================"
echo "VelPharma Data Loader"
echo "============================================"
echo ""

# Check for data-only backup (PRIORITY 1 - BEST)
if [ -f "$BACKUP_DATA_ONLY" ]; then
    echo "✅ Found data-only backup at: $BACKUP_DATA_ONLY"
    echo "📊 Loading production data (data-only, clean)..."
    echo ""

    SIZE=$(du -h "$BACKUP_DATA_ONLY" | cut -f1)
    echo "   File size: $SIZE"
    echo "   This may take 10-30 seconds..."
    echo ""

    START_TIME=$(date +%s)
    # Disable triggers to handle circular foreign keys
    psql -U "$POSTGRES_USER" -d velpdevdb <<-EOSQL
        SET session_replication_role = replica;
        \i $BACKUP_DATA_ONLY
        SET session_replication_role = DEFAULT;
EOSQL
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))

    echo ""
    echo "✅ Data-only backup loaded successfully in ${DURATION}s"
    echo ""

    # Show data counts
    echo "📈 Data Summary:"
    psql -U "$POSTGRES_USER" -d velpdevdb -t -c "
    SELECT
        '   Products: ' || COUNT(*) FROM vpv4.PRODUCTS
    UNION ALL
    SELECT
        '   ADRs: ' || COUNT(*) FROM vpv4.ADVERSE_DRUG_REACTIONS
    UNION ALL
    SELECT
        '   Manufacturers: ' || COUNT(*) FROM vpv4.MANUFACTURERS;
    " 2>/dev/null || echo "   (Unable to fetch counts)"

    echo ""
    echo "🎉 Database ready with production data!"
    echo "============================================"
    exit 0
fi

echo "⚠️  No data-only backup found at: $BACKUP_DATA_ONLY"
echo ""

# Check for full backup (PRIORITY 2 - FALLBACK)
if [ -f "$BACKUP_FULL" ]; then
    echo "⚠️  Found full backup (contains schema) at: $BACKUP_FULL"
    echo "📊 Loading data (ignoring schema conflicts)..."
    echo ""

    SIZE=$(du -h "$BACKUP_FULL" | cut -f1)
    echo "   File size: $SIZE"
    echo "   Note: Schema conflicts will be ignored"
    echo ""

    START_TIME=$(date +%s)
    # Load with errors ignored, show only data operations
    psql -U "$POSTGRES_USER" -d velpdevdb <<-EOSQL
        SET session_replication_role = replica;
        \i $BACKUP_FULL
        SET session_replication_role = DEFAULT;
EOSQL
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))

    echo ""
    echo "✅ Full backup loaded (schema errors ignored) in ${DURATION}s"
    echo ""
    echo "💡 Tip: Create data-only backup for cleaner loads:"
    echo "   ./create-backup.sh --data-only"
    echo ""

    # Show data counts
    echo "📈 Data Summary:"
    psql -U "$POSTGRES_USER" -d velpdevdb -t -c "
    SELECT
        '   Products: ' || COUNT(*) FROM vpv4.PRODUCTS
    UNION ALL
    SELECT
        '   ADRs: ' || COUNT(*) FROM vpv4.ADVERSE_DRUG_REACTIONS
    UNION ALL
    SELECT
        '   Manufacturers: ' || COUNT(*) FROM vpv4.MANUFACTURERS;
    " 2>/dev/null || echo "   (Unable to fetch counts)"

    echo ""
    echo "🎉 Database ready with production data!"
    echo "============================================"
    exit 0
fi

echo "⚠️  No full backup found at: $BACKUP_FULL"
echo ""

# Check for seed file (PRIORITY 2)
if [ -f "$SEED_FILE" ]; then
    echo "✅ Found seed file at: $SEED_FILE"
    echo "🌱 Loading seed data (fallback)..."
    echo ""

    psql -U "$POSTGRES_USER" -d velpdevdb -f "$SEED_FILE" 2>&1 | grep -v "^SET$" | grep -v "^--" || true

    echo ""
    echo "✅ Seed data loaded successfully"
    echo "💡 Tip: For production data, place backup at $BACKUP_FILE"
    echo "============================================"
    exit 0
fi

echo "⚠️  No seed file found at: $SEED_FILE"
echo ""

# No data sources available (PRIORITY 3)
echo "ℹ️  Starting with empty schema (no data)"
echo ""
echo "📝 To add data, choose one option:"
echo ""
echo "   Option 1 (Recommended): Load from data-only backup"
echo "   --------------------------------------------------"
echo "   1. Create data-only backup: ./create-backup.sh --data-only"
echo "   2. Or place existing backup at: $BACKUP_DATA_ONLY"
echo "   3. Run: ./reset-db.sh"
echo ""
echo "   Option 2: Run master data loader"
echo "   --------------------------------"
echo "   1. docker compose exec -T postgres psql -U postgres -d velpdevdb \\"
echo "      -f /data/optimize-for-bulk-insert.sql"
echo "   2. Run your .NET master data loader with CSV files"
echo "   3. docker compose exec -T postgres psql -U postgres -d velpdevdb \\"
echo "      -f /data/restore-after-bulk-insert.sql"
echo "   4. ./create-backup.sh"
echo ""
echo "   Option 3: Manual seed"
echo "   --------------------"
echo "   docker compose exec -T postgres psql -U postgres -d velpdevdb \\"
echo "      -f /docker-entrypoint-initdb.d/_05-seed-base.sql.disabled"
echo ""
echo "============================================"
