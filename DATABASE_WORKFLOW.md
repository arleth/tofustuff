# VelPharma Database Workflow & Strategy

## 📋 Table of Contents
1. [Overview](#overview)
2. [Architecture Decision](#architecture-decision)
3. [Workflows](#workflows)
4. [File Structure](#file-structure)
5. [Detailed Procedures](#detailed-procedures)
6. [Troubleshooting](#troubleshooting)

---

## Overview

This document describes the VelPharma database initialization and update strategy. The approach is optimized for:
- **Fast local development setup** (load from backup in seconds)
- **Monthly data updates** (new products & ADRs from master data loader)
- **Team synchronization** (everyone works with same dataset)
- **Fallback options** (manual seed when needed)

### Key Principle
> **Backup-first approach**: Use production data snapshots for development, update monthly, maintain seed files as fallback.

---

## Architecture Decision

### Why This Approach?

**Problem**: Master data loader is slow for bulk ADR inserts (~thousands of records with complex relationships)

**Solution**:
- Load from pre-populated backup file (fast: ~5-10 seconds)
- Use master data loader only for monthly updates
- Keep seed SQL files as manual fallback option

### Data Sources Priority

```
1. Local Docker Backup (PRIMARY) ⭐
   └─> Source: Local Docker postgres container
   └─> File: backups/production_backup_data_only.sql
   └─> Distributed via: Git repository
   └─> Updated: Monthly (after master data loader runs)
   └─> Flow: Load CSVs → Docker → Create backup → Commit to Git

2. Azure Production Backup (NUCLEAR OPTION)
   └─> Source: velp-dev-dbserver.postgres.database.azure.com
   └─> Script: ./backup-from-azure.sh --data-only
   └─> Used for: Emergency restart from production
   └─> One-time use: Initial Docker setup migration

3. Seed SQL Files (MANUAL FALLBACK)
   └─> Files: postgres/init/_05-seed-base.sql.disabled (disabled by extension)
   └─> Used for: Manual/custom setup scenarios
   └─> Note: Renamed to .sql.disabled to prevent auto-execution

4. Empty Schema (LAST RESORT)
   └─> Just tables, no data
```

**Key Principle**: Everything runs against LOCAL Docker postgres. Azure is only for emergency situations.

---

## Workflows

### 1. Developer Onboarding (First Time Setup)

**Goal**: Get a working database with full production-like data in under 1 minute

```bash
# Step 1: Clone repository
git clone <repo-url>
cd my-infra

# Step 2: Get production backup
# Option A: Download from shared storage
curl -o backups/production_backup.sql https://your-storage/latest-backup.sql

# Option B: Copy from local backup archive
cp ~/velpharma-backups/production_backup.sql backups/

# Option C: Ask team lead for latest backup file

# Step 3: Initialize infrastructure
tofu init
tofu apply

# Step 4: Start database with data
./reset-db.sh
```

**Result**:
- ✅ Database running on port 5434
- ✅ All tables created
- ✅ Production data loaded (~XX products, XX ADRs)
- ✅ Ready for development

**Time**: ~30-60 seconds

---

### 2. Monthly Data Update (Data Manager Workflow)

**Goal**: Update LOCAL Docker database with new products and ADRs, then distribute via Git

**Frequency**: Once per month (or when new data arrives)

**Prerequisites**:
- Master Data Loader tool (.NET application)
- CSV files with new products/manufacturers/ADRs
- Local Docker database running with existing data (from previous backup)

#### Procedure

```bash
# ================================================
# PHASE 1: PREPARE DATABASE FOR BULK OPERATIONS
# ================================================

# Step 1: Optimize database for bulk inserts
docker compose exec -T postgres psql -U postgres -d velpdevdb \
  -f /data/optimize-for-bulk-insert.sql

# Expected output:
# ✅ Autovacuum disabled for ADR tables
# ✅ Ready for bulk operations


# ================================================
# PHASE 2: RUN MASTER DATA LOADER
# ================================================

# Step 2: Place CSV files in data directory
cp ~/downloads/new-products-2025-11.csv data/
cp ~/downloads/new-adrs-2025-11.csv data/

# Step 3: Run your .NET master data loader
cd /path/to/master-data-loader
dotnet run -- --connection "Host=localhost;Port=5434;Database=velpdevdb;Username=postgres;Password=changeme"

# Monitor progress:
# - Products: Fast (~seconds)
# - Manufacturers: Fast (~seconds)
# - ADRs: Slow (~minutes due to relationships)

# Step 4: Monitor database during load (in another terminal)
cd /path/to/my-infra
./monitor-db.sh


# ================================================
# PHASE 3: RESTORE DATABASE PERFORMANCE
# ================================================

# Step 5: Restore normal database operations
docker compose exec -T postgres psql -U postgres -d velpdevdb \
  -f /data/restore-after-bulk-insert.sql

# Expected output:
# ✅ Autovacuum re-enabled
# ✅ Statistics updated (ANALYZE)
# ✅ Space reclaimed (VACUUM)


# ================================================
# PHASE 4: CREATE NEW BACKUP FROM LOCAL DOCKER
# ================================================

# Step 6: Create backup from LOCAL Docker database
./create-backup.sh --data-only

# The script will:
# - Export data-only (no schema) from local Docker postgres
# - Create timestamped backup: production_backup_data_only_YYYYMMDD_HHMMSS.sql
# - Copy to: backups/production_backup_data_only.sql (tracked in Git)
# - Show table counts and backup size

# Step 7: Verify backup contents
ls -lh backups/production_backup_data_only.sql
wc -l backups/production_backup_data_only.sql
grep "Data for Name:" backups/production_backup_data_only.sql


# ================================================
# PHASE 5: COMMIT TO GIT AND SHARE WITH TEAM
# ================================================

# Step 8: Commit updated backup to Git
git add backups/production_backup_data_only.sql
git commit -m "Monthly data update: $(date +%Y-%m-%d)

- Updated products and ADRs from master data loader
- Products: $(docker compose exec -T postgres psql -U postgres -d velpdevdb -t -c 'SELECT COUNT(*) FROM vpv4.products' | xargs)
- ADRs: $(docker compose exec -T postgres psql -U postgres -d velpdevdb -t -c 'SELECT COUNT(*) FROM vpv4.adverse_drug_reactions' | xargs)
- Backup size: $(du -h backups/production_backup_data_only.sql | cut -f1)
"

# Step 9: Push to repository
git push origin master

# Step 10: Notify team
# "📦 Monthly data update pushed to Git
#  Run: git pull && ./reset-db.sh to update your local database"
```

**Important**: If backup file exceeds 50MB, see [Git LFS setup](#backup-too-large-for-git) in Troubleshooting section.

**Time Estimates**:
- Optimize: ~1 second
- Load data via master data loader: ~5-30 minutes (depends on CSV size)
- Restore: ~30 seconds
- Create backup from Docker: ~10 seconds
- Commit and push to Git: ~10-30 seconds (depends on backup size)
- **Total**: ~10-35 minutes

---

### 3. Daily Development (Using Existing Database)

**Goal**: Work with stable, existing database

```bash
# Start database (preserves data)
docker compose up -d

# Stop database
docker compose down

# View logs
docker compose logs -f postgres

# Monitor performance
./monitor-db.sh
```

**No data loss**: Data persists in Docker volumes

---

### 4. Fresh Start (Reset Everything)

**Goal**: Start over with clean slate and latest data from Git

**When to use**:
- After `git pull` to get updated data
- Local database is corrupted or has test data
- Want to sync with team's latest dataset
- Messed up local changes and need fresh start

```bash
# Typical workflow:
git pull                 # Get latest backup from team
./reset-db.sh           # Reset with new data
```

#### What reset-db.sh Does (Step by Step)

```bash
./reset-db.sh
```

**Flow**:
1. 🗑️ Stop containers (`docker compose down -v`)
2. 🗑️ Delete volumes (destroys ALL local database data)
3. 🔨 Rebuild Docker image (includes init scripts)
4. 🚀 Start postgres container
5. 📦 **Init scripts run automatically** (in this order):
   - `01-create-user.sql` → Create postgres user
   - `02-create-schema.sql` → Create vpv4 schema + tables
   - `03-create-extensions.sql` → Install PostgreSQL extensions
   - `04-load-data.sh` → **Load from backups/production_backup_data_only.sql** ⭐
6. ✅ Database ready with production data (2,281 products, 29,222 ADRs, etc.)

**Time**: 30-60 seconds total

**Warning**: ⚠️ This deletes ALL local database changes! Make sure you've backed up any local work first.

---

### 5. Manual Seed (Fallback Option)

**Goal**: Start from scratch without backup (e.g., backup corrupted, need minimal data)

**When to use**:
- Backup file missing or corrupted
- Want minimal seed data only
- Testing schema changes without production data

```bash
# Step 1: Remove or rename backup
mv backups/production_backup_data_only.sql backups/production_backup_data_only.sql.old

# Step 2: Enable seed file (if disabled)
# The seed file is named _05-seed-base.sql.disabled
# Docker only runs files ending in .sql or .sh

# Option A: Temporarily enable seed during init
docker compose down -v
cp postgres/init/_05-seed-base.sql.disabled postgres/init/05-seed-base.sql
docker compose up -d --build
rm postgres/init/05-seed-base.sql  # Clean up after init

# Option B: Manually run seed after init
./reset-db.sh  # Creates empty schema
docker compose exec -T postgres psql -U postgres -d velpdevdb \
  -f /docker-entrypoint-initdb.d/_05-seed-base.sql.disabled

# Step 3: Run master data loader with full CSV files
# (Follow Monthly Data Update workflow from Phase 2)

# Step 4: Create new backup
./create-backup.sh --data-only
```

---

## File Structure

```
my-infra/
├── postgres/
│   ├── Dockerfile                          # PostgreSQL image with extensions
│   └── init/                               # Initialization scripts (run in order)
│       ├── 01-create-user.sql             # Create database users
│       ├── 02-create-schema.sql           # Create all tables & indexes
│       ├── 03-create-extensions.sql       # Install PostgreSQL extensions
│       ├── 04-load-data.sh                # Smart data loader (BACKUP → SEED → EMPTY)
│       └── _05-seed-base.sql              # Seed data (fallback, underscore = disabled)
│
├── backups/
│   ├── .gitkeep                           # Keep directory in git
│   ├── production_backup.sql              # CURRENT production backup (used by default)
│   ├── production_backup_YYYYMMDD.sql     # Dated backups (history)
│   └── README.md                          # Backup management instructions
│
├── data/
│   ├── README.md                          # Place CSV files here
│   ├── optimize-for-bulk-insert.sql       # Pre-load optimization
│   ├── restore-after-bulk-insert.sql      # Post-load cleanup
│   └── analyze-performance.sql            # Performance analysis queries
│
├── docker-compose.yml                      # Service orchestration
├── reset-db.sh                            # Complete database reset
├── create-backup.sh                       # Create new backup
├── monitor-db.sh                          # Real-time monitoring
├── main.tf                                # OpenTofu configuration
├── variables.tf                           # Configuration variables
├── DATABASE_WORKFLOW.md                   # This document
└── README.md                              # Quick start guide
```

---

## Detailed Procedures

### Creating a Backup

```bash
# Using helper script (recommended)
./create-backup.sh

# Manual process
DATE=$(date +%Y%m%d_%H%M%S)
docker compose exec postgres pg_dump -U postgres velpdevdb \
  > "backups/production_backup_${DATE}.sql"

# Verify backup
ls -lh backups/production_backup_${DATE}.sql
# Should be ~10-20MB depending on data

# Set as production backup
cp "backups/production_backup_${DATE}.sql" backups/production_backup.sql

# Compress old backups
gzip backups/production_backup_20*.sql
```

### Restoring from Specific Backup

```bash
# List available backups
ls -lh backups/

# Copy desired backup as production
cp backups/production_backup_20251015_120024.sql backups/production_backup.sql

# Reset database (will load the backup you just set)
./reset-db.sh
```

### Backup Management Strategy

**Storage**:
- ✅ Keep last 3 monthly backups locally
- ✅ Archive older backups to cloud storage
- ✅ Compress old backups with gzip

**Naming Convention**:
```
production_backup.sql                    # Current/latest (uncompressed)
production_backup_YYYYMMDD_HHMMSS.sql   # Dated snapshots
production_backup_YYYYMMDD_HHMMSS.sql.gz # Compressed archives
```

**Git Strategy**:
```gitignore
# In .gitignore
backups/*.sql          # Don't commit large SQL files
!backups/.gitkeep      # Keep directory structure
```

**Options for Team Distribution**:
1. **Shared Drive**: Dropbox, Google Drive, OneDrive
2. **Cloud Storage**: AWS S3, Azure Blob, Google Cloud Storage
3. **Git LFS**: For version control of large files
4. **Internal Server**: Company file server
5. **Direct Share**: Slack, Teams, email (for smaller backups)

---

## Troubleshooting

### Backup Not Loading

**Symptom**: Database starts but no data

**Diagnosis**:
```bash
# Check if backup exists
ls -lh backups/production_backup.sql

# Check database has data
docker compose exec postgres psql -U postgres -d velpdevdb -c "
SELECT COUNT(*) FROM vpv4.products;
"
```

**Solutions**:
```bash
# Solution 1: Verify backup location
mv your-backup.sql backups/production_backup.sql
./reset-db.sh

# Solution 2: Check init logs
docker compose logs postgres | grep "load-data"

# Solution 3: Manual restore
./reset-db.sh  # Creates empty schema
docker compose exec -T postgres psql -U postgres -d velpdevdb \
  < backups/production_backup.sql
```

---

### Master Data Loader Slow

**Symptom**: ADR inserts taking too long

**Diagnosis**:
```bash
# Monitor during load
./monitor-db.sh

# Check for long-running queries
docker compose exec postgres psql -U postgres -d velpdevdb -c "
SELECT pid, now() - query_start AS duration, state, query
FROM pg_stat_activity
WHERE state = 'active' AND query NOT LIKE '%pg_stat_activity%';
"
```

**Solutions**:
1. **Did you optimize?**
   ```bash
   docker compose exec -T postgres psql -U postgres -d velpdevdb \
     -f /data/optimize-for-bulk-insert.sql
   ```

2. **Use batching in .NET**:
   ```csharp
   context.ChangeTracker.AutoDetectChangesEnabled = false;
   // Batch inserts of 1000 records
   ```

3. **Use bulk extensions**:
   ```csharp
   await context.BulkInsertAsync(entities);
   ```

4. **Check indexes**:
   ```bash
   docker compose exec -T postgres psql -U postgres -d velpdevdb \
     -f /data/analyze-performance.sql
   ```

---

### Backup Too Large for Git

**Symptom**: Cannot commit/push backup file

**Solution 1: Use Git LFS**
```bash
# Install Git LFS
brew install git-lfs
git lfs install

# Track SQL files
git lfs track "backups/*.sql"
git add .gitattributes
git commit -m "Track backups with Git LFS"

# Now commit backup
git add backups/production_backup.sql
git commit -m "Add production backup"
git push
```

**Solution 2: External Storage**
```bash
# Upload to cloud storage
aws s3 cp backups/production_backup.sql \
  s3://velpharma-backups/production_backup.sql

# Document download location
echo "Download from: aws s3 cp s3://velpharma-backups/production_backup.sql backups/" \
  > backups/README.md
```

**Solution 3: Compress**
```bash
gzip backups/production_backup.sql
# Commit the .gz file instead (much smaller)
```

---

### Different Data Across Team

**Symptom**: Colleagues have different data than you

**Cause**: Different backup versions

**Solution**:
```bash
# Check your backup date
ls -l backups/production_backup_data_only.sql

# Check data counts
docker compose exec postgres psql -U postgres -d velpdevdb -c "
SELECT
  'products' as table_name, COUNT(*) FROM vpv4.products
UNION ALL
SELECT 'adrs', COUNT(*) FROM vpv4.adverse_drug_reactions;
"

# Get latest backup from Azure production
./backup-from-azure.sh --data-only

# Reset with new backup
./reset-db.sh
```

---

## Azure Production Database (Emergency Use Only)

### ⚠️ Important: This is NOT part of the regular workflow!

The Azure database was used for the **initial migration** to get production data into Docker. Going forward, all development and monthly updates run against **LOCAL Docker postgres**.

### When to Use Azure Backup (Nuclear Option)

Use `./backup-from-azure.sh` only in these situations:
- 🚨 Local backup is corrupted and no team member has a good copy
- 🚨 Need to verify local schema matches Azure production
- 🚨 Starting completely fresh after major changes
- 🚨 Emergency recovery scenario

**Regular workflow**: Use local Docker backups distributed via Git!

### Connection Details

```
Host:     velp-dev-dbserver.postgres.database.azure.com
Port:     5432
Database: velpdevdb
Schema:   vpv4
Username: velpharma
Password: velpharma (prompted at runtime)
```

### Emergency Backup from Azure

```bash
# Nuclear option: Get fresh dump from Azure
./backup-from-azure.sh --data-only

# This will:
# - Connect to Azure production database
# - Export data-only from vpv4 schema
# - Save to backups/production_backup_data_only.sql
# - Overwrite existing local backup

# Then reset:
./reset-db.sh
```

### Regular Workflow (No Azure Needed)

```bash
# Monthly update flow (LOCAL DOCKER ONLY):
# 1. Run master data loader against localhost:5434
# 2. Create backup FROM local Docker:
./create-backup.sh --data-only

# 3. Commit to Git:
git add backups/production_backup_data_only.sql
git commit -m "Monthly data update"
git push

# Team pulls and resets:
git pull && ./reset-db.sh
```

### Security Notes

- Azure password prompted at runtime (not stored in files)
- Uses `PGPASSWORD` environment variable
- Connection encrypted (Azure enforces SSL)
- Only vpv4 schema exported (avoids vpv3 permission issues)

**Prevention**: Document backup version in commit message or shared doc

---

## Summary

### Quick Reference

| Scenario | Command | Time |
|----------|---------|------|
| **First time setup** | `./reset-db.sh` | 30-60s |
| **Daily work** | `docker compose up -d` | 5s |
| **Monthly update** | See "Monthly Data Update" | 10-35min |
| **Reset everything** | `./reset-db.sh` | 30-60s |
| **Create backup** | `./create-backup.sh` | 10s |
| **Monitor performance** | `./monitor-db.sh` | instant |

### Key Files

| File | Purpose |
|------|---------|
| `backups/production_backup.sql` | Current production data (auto-loaded) |
| `postgres/init/04-load-data.sh` | Smart loader (backup → seed → empty) |
| `postgres/init/_05-seed-base.sql` | Fallback seed data (disabled by default) |
| `data/optimize-for-bulk-insert.sql` | Pre-load optimization |
| `data/restore-after-bulk-insert.sql` | Post-load cleanup |

### Decision Tree

```
Need database?
│
├─ First time? ──> Get backup ──> ./reset-db.sh
│
├─ Daily work? ──> docker compose up -d
│
├─ New data arrived? ──> Follow "Monthly Data Update"
│
├─ Database broken? ──> ./reset-db.sh
│
└─ No backup available? ──> Follow "Manual Seed"
```

---

## Maintenance

### Weekly
- Monitor database size: `docker compose exec postgres psql -U postgres -d velpdevdb -c "\l+"`
- Check logs: `docker compose logs postgres | tail -100`

### Monthly
- Update production backup (after master data loader run)
- Archive old backups (compress and move to cloud)
- Verify team members can access latest backup

### Quarterly
- Review and clean old backups
- Update documentation if workflow changes
- Test disaster recovery (backup → restore process)

---

**Document Version**: 1.0
**Last Updated**: 2025-10-16
**Maintained By**: VelPharma Infrastructure Team
