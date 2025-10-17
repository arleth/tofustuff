# VelPharma Infrastructure

Local Docker-based development environment managed with OpenTofu.

## Quick Start

```bash
# First time setup or get latest data
git pull
./reset-db.sh

# Database ready in 30-60 seconds with production data!
```

## Services

| Service | URL/Connection | Credentials |
|---------|----------------|-------------|
| PostgreSQL | `localhost:5434` | postgres / changeme |
| PgAdmin | http://localhost:5050 | admin@velpharma.com / admin |

**Connection string:**
```
postgresql://postgres:changeme@localhost:5434/velpdevdb
```

## Documentation

- **[QUICK_START.md](QUICK_START.md)** - Common commands and daily workflows
- **[DATABASE_WORKFLOW.md](DATABASE_WORKFLOW.md)** - Complete data management guide
- **[backups/README.md](backups/README.md)** - Backup strategy and monthly updates

## Key Scripts

| Script | Purpose |
|--------|---------|
| `./reset-db.sh` | Reset database (loads from Git backup) |
| `./create-backup.sh` | Create backup from local Docker |
| `./backup-from-azure.sh` | Emergency: Export from Azure production |
| `./monitor-db.sh` | Monitor database performance |

## Common Commands

```bash
# Start database (keeps existing data)
docker compose up -d

# Stop database
docker compose down

# View logs
docker compose logs -f postgres

# Connect via psql
docker compose exec postgres psql -U postgres -d velpdevdb
```

## Infrastructure Management

This project uses OpenTofu to generate configuration files:

```bash
# Initialize OpenTofu
tofu init

# Apply changes (regenerates .env and this README)
tofu apply

# Modify settings in variables.tf, then apply
```

## Data Strategy

- **Production backup** tracked in Git (`backups/production_backup_data_only.sql`)
- **Monthly updates** run against LOCAL Docker, then committed to Git
- **Team sync** via `git pull && ./reset-db.sh`
- **Azure backup** available for emergencies only

See [DATABASE_WORKFLOW.md](DATABASE_WORKFLOW.md) for complete details.

## Troubleshooting

| Issue | Solution |
|-------|----------|
| No data after reset | Check logs: `docker compose logs postgres` |
| Port conflict | Edit `variables.tf`, change `db_port`, run `tofu apply` |
| PgAdmin can't connect | Use host `postgres` (not localhost), port `5432` |
| Database won't start | Run `docker compose down -v && ./reset-db.sh` |

For detailed troubleshooting, see [DATABASE_WORKFLOW.md](DATABASE_WORKFLOW.md#troubleshooting).
