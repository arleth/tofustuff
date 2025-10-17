-- Optimize PostgreSQL for bulk insert operations
-- Run BEFORE bulk inserts: docker compose exec -T postgres psql -U postgres -d velpdevdb -f /data/optimize-for-bulk-insert.sql

\echo '=========================================='
\echo 'Optimizing for Bulk Insert Operations'
\echo '=========================================='
\echo ''

-- Disable autovacuum temporarily for bulk operations
ALTER TABLE vpv4.ADVERSE_DRUG_REACTIONS SET (autovacuum_enabled = false);
ALTER TABLE vpv4.PRODUCTS_ADVERSE_DRUG_REACTIONS_FREQUENCIES SET (autovacuum_enabled = false);
ALTER TABLE vpv4.ADVERSE_DRUG_REACTIONS_ORGANS SET (autovacuum_enabled = false);
ALTER TABLE vpv4.ADVERSE_DRUG_REACTIONS_PARA_CLINICS SET (autovacuum_enabled = false);
ALTER TABLE vpv4.ADVERSE_DRUG_REACTIONS_SPECIALTIES SET (autovacuum_enabled = false);

\echo '✅ Autovacuum disabled for ADR tables'
\echo ''
\echo '⚡ Bulk Insert Best Practices:'
\echo '  1. Use COPY command instead of INSERT when possible'
\echo '  2. Wrap inserts in a single transaction (BEGIN/COMMIT)'
\echo '  3. Consider temporarily dropping indexes before bulk insert'
\echo '  4. Use UNLOGGED tables for temporary staging'
\echo '  5. Increase work_mem for the session'
\echo ''
\echo '📋 After bulk insert, run: restore-after-bulk-insert.sql'
\echo '=========================================='

-- Increase work_mem for bulk operations (session-level)
-- SET work_mem = '256MB';  -- Uncomment if running in same session as inserts
