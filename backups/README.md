# VelPharma Database Backups

## Current Production Backup

**File**: `production_backup_data_only.sql`
**Status**: ✅ Tracked in Git
**Size**: ~11MB
**Last Updated**: Run `git log backups/production_backup_data_only.sql` to see history

This file contains **data-only** (no schema) from the vpv4 schema and is automatically loaded when you run `./reset-db.sh`.

### Data Contents

- **Products**: 2,281
- **Adverse Drug Reactions**: 29,222
- **Manufacturers**: 306
- **ATC Codes**: 6,808
- **Active Substances**: 73
- **Organs**: 42

## Workflow

### For Developers (Getting Latest Data)

```bash
# Pull latest backup from Git
git pull

# Reset database with new data
./reset-db.sh

# Database is ready in 30-60 seconds!
```

### For Data Manager (Monthly Updates)

```bash
# 1. Start with current data
git pull && ./reset-db.sh

# 2. Place new CSV files in data/ folder
cp ~/downloads/*.csv data/

# 3. Run master data loader against localhost:5434
cd /path/to/master-data-loader
dotnet run -- --connection "Host=localhost;Port=5434;Database=velpdevdb;Username=postgres;Password=changeme"

# 4. Create backup from LOCAL Docker
cd /path/to/my-infra
./create-backup.sh --data-only

# 5. Commit and push to Git
git add backups/production_backup_data_only.sql
git commit -m "Monthly data update: $(date +%Y-%m-%d)"
git push

# 6. Notify team to pull and reset
```

## File Naming Convention

| File Pattern | Tracked in Git | Purpose |
|--------------|----------------|---------|
| `production_backup_data_only.sql` | ✅ YES | Current production backup, distributed via Git |
| `production_backup_data_only_YYYYMMDD_HHMMSS.sql` | ❌ NO | Timestamped backups for local archiving |
| `azure_production_data_only_YYYYMMDD_HHMMSS.sql` | ❌ NO | Emergency Azure exports (nuclear option) |
| `production_backup_full_YYYYMMDD_HHMMSS.sql` | ❌ NO | Full backups (schema + data) for reference |

## Emergency: Backup from Azure Production

**⚠️ Only use in emergency situations!**

```bash
# Get fresh dump from Azure (overwrites local backup)
./backup-from-azure.sh --data-only

# Reset database
./reset-db.sh
```

### When to Use Azure Backup

- 🚨 Local backup corrupted and no team member has good copy
- 🚨 Need to verify schema matches Azure production
- 🚨 Complete fresh start after major changes

**Regular workflow uses LOCAL Docker backups only!**

## Git LFS (For Future)

If backup file grows beyond 50MB, consider using Git LFS:

```bash
# Install Git LFS
brew install git-lfs
git lfs install

# Track the backup file
git lfs track "backups/production_backup_data_only.sql"
git add .gitattributes
git commit -m "Track backups with Git LFS"
```

## Troubleshooting

### Backup File Missing After Git Pull

```bash
# Check if file exists
ls -lh backups/production_backup_data_only.sql

# If missing, check Git LFS status
git lfs ls-files

# Pull LFS files
git lfs pull
```

### Database Reset Shows "No Data"

Check the 04-load-data.sh output:
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

## See Also

- Full workflow documentation: [DATABASE_WORKFLOW.md](../DATABASE_WORKFLOW.md)
- Reset database script: [reset-db.sh](../reset-db.sh)
- Create backup script: [create-backup.sh](../create-backup.sh)
- Azure backup (emergency): [backup-from-azure.sh](../backup-from-azure.sh)
