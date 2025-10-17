# VelPharma Database - Quick Start Guide

## 🚀 For Developers (First Time Setup)

```bash
# 1. Clone repository (includes production backup in backups/)
git clone <repo-url>
cd my-infra

# 2. Reset database (loads production data automatically)
./reset-db.sh

# 3. Wait 30-60 seconds

# 4. Done! Database is ready with production data:
#    - Products: 2,281
#    - ADRs: 29,222
#    - Manufacturers: 306
```

Connect to database:
- **PostgreSQL**: `postgresql://postgres:changeme@localhost:5434/velpdevdb`
- **PgAdmin**: http://localhost:5050

---

## 🔄 Getting Latest Data (After Team Updates)

```bash
# Pull latest backup from Git
git pull

# Reset database with new data
./reset-db.sh
```

---

## 📦 Monthly Data Update (Data Manager Only)

```bash
# 1. Get current data
git pull && ./reset-db.sh

# 2. Place CSV files in data/ folder
cp ~/downloads/*.csv data/

# 3. Run master data loader against LOCAL Docker (port 5434)
cd /path/to/master-data-loader
dotnet run -- --connection "Host=localhost;Port=5434;Database=velpdevdb;Username=postgres;Password=changeme"

# 4. Create backup from LOCAL Docker
cd /path/to/my-infra
./create-backup.sh --data-only

# 5. Commit to Git
git add backups/production_backup_data_only.sql
git commit -m "Monthly data update: $(date +%Y-%m-%d)

- New products: XX
- New ADRs: YY
- Backup size: $(du -h backups/production_backup_data_only.sql | cut -f1)
"
git push

# 6. Notify team: "📦 New data pushed! Run: git pull && ./reset-db.sh"
```

---

## 🔧 Common Commands

```bash
# Start database (keeps existing data)
docker compose up -d

# Stop database
docker compose down

# View logs
docker compose logs -f postgres

# Connect via psql
docker compose exec postgres psql -U postgres -d velpdevdb

# Monitor performance
./monitor-db.sh

# Reset everything (fresh start)
./reset-db.sh
```

---

## 🚨 Emergency: Restore from Azure Production

**⚠️ Only use if local backup is corrupted!**

```bash
# Get fresh dump from Azure (overwrites local backup)
./backup-from-azure.sh --data-only

# Reset database
./reset-db.sh
```

---

## 📁 Key Files

| File | Purpose |
|------|---------|
| [reset-db.sh](reset-db.sh) | Reset database with fresh data from Git backup |
| [create-backup.sh](create-backup.sh) | Create backup from LOCAL Docker |
| [backup-from-azure.sh](backup-from-azure.sh) | Emergency: Export from Azure production |
| [backups/production_backup_data_only.sql](backups/production_backup_data_only.sql) | Current production data (tracked in Git) |
| [DATABASE_WORKFLOW.md](DATABASE_WORKFLOW.md) | Complete workflow documentation |
| [backups/README.md](backups/README.md) | Backup management guide |

---

## 📊 Understanding reset-db.sh Flow

When you run `./reset-db.sh`, here's what happens:

1. 🗑️ **Tear down**: Stop containers, delete volumes (destroys local data)
2. 🔨 **Rebuild**: Rebuild Docker image with init scripts
3. 🚀 **Start**: Launch postgres container
4. 📦 **Init scripts run automatically**:
   - `01-create-user.sql` → Create postgres user
   - `02-create-schema.sql` → Create vpv4 schema + tables
   - `03-create-extensions.sql` → Install PostgreSQL extensions
   - `04-load-data.sh` → **Load from backups/production_backup_data_only.sql** ⭐
5. ✅ **Ready**: Database has full production data

**Time**: 30-60 seconds total

---

## 💡 Key Principles

1. **Everything runs against LOCAL Docker postgres** (port 5434)
2. **Backups distributed via Git** (backups/production_backup_data_only.sql)
3. **Azure is for emergencies only** (not regular workflow)
4. **Master data loader runs monthly** (not for daily setup)
5. **reset-db.sh loads from Git backup** (fast setup in seconds)

---

## 🆘 Troubleshooting

### Database has no data after reset

Check the init logs:
```bash
docker compose logs postgres | grep "VelPharma Data Loader" -A 30
```

Should show:
```
✅ Found data-only backup at: /backups/production_backup_data_only.sql
✅ Data-only backup loaded successfully
   Products: 2281
   ADRs: 29222
```

### Backup file missing after git pull

```bash
# Check if file exists
ls -lh backups/production_backup_data_only.sql

# If using Git LFS (future)
git lfs pull
```

### Database won't start

```bash
# Check container status
docker compose ps

# View full logs
docker compose logs postgres

# Nuclear option: complete reset
docker compose down -v
docker system prune -a
./reset-db.sh
```

---

## 📖 Full Documentation

For complete workflow details, see [DATABASE_WORKFLOW.md](DATABASE_WORKFLOW.md)
