-- Restore normal operations after bulk insert
-- Run AFTER bulk inserts: docker compose exec -T postgres psql -U postgres -d velpdevdb -f /data/restore-after-bulk-insert.sql

\echo '=========================================='
\echo 'Restoring Normal Operations After Bulk Insert'
\echo '=========================================='
\echo ''

-- Re-enable autovacuum
ALTER TABLE vpv4.ADVERSE_DRUG_REACTIONS SET (autovacuum_enabled = true);
ALTER TABLE vpv4.PRODUCTS_ADVERSE_DRUG_REACTIONS_FREQUENCIES SET (autovacuum_enabled = true);
ALTER TABLE vpv4.ADVERSE_DRUG_REACTIONS_ORGANS SET (autovacuum_enabled = true);
ALTER TABLE vpv4.ADVERSE_DRUG_REACTIONS_PARA_CLINICS SET (autovacuum_enabled = true);
ALTER TABLE vpv4.ADVERSE_DRUG_REACTIONS_SPECIALTIES SET (autovacuum_enabled = true);

\echo '✅ Autovacuum re-enabled'
\echo ''

-- Analyze tables to update statistics
\echo '📊 Analyzing tables...'
ANALYZE vpv4.ADVERSE_DRUG_REACTIONS;
ANALYZE vpv4.PRODUCTS_ADVERSE_DRUG_REACTIONS_FREQUENCIES;
ANALYZE vpv4.ADVERSE_DRUG_REACTIONS_ORGANS;
ANALYZE vpv4.ADVERSE_DRUG_REACTIONS_PARA_CLINICS;
ANALYZE vpv4.ADVERSE_DRUG_REACTIONS_SPECIALTIES;

\echo '✅ Analysis complete'
\echo ''

-- Vacuum to reclaim space
\echo '🧹 Vacuuming tables...'
VACUUM ANALYZE vpv4.ADVERSE_DRUG_REACTIONS;
VACUUM ANALYZE vpv4.PRODUCTS_ADVERSE_DRUG_REACTIONS_FREQUENCIES;
VACUUM ANALYZE vpv4.ADVERSE_DRUG_REACTIONS_ORGANS;
VACUUM ANALYZE vpv4.ADVERSE_DRUG_REACTIONS_PARA_CLINICS;
VACUUM ANALYZE vpv4.ADVERSE_DRUG_REACTIONS_SPECIALTIES;

\echo '✅ Vacuum complete'
\echo ''
\echo '=========================================='
\echo '✅ Database optimizations restored'
\echo '=========================================='
