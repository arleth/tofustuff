-- VelPharma Database Performance Analysis
-- Run with: docker compose exec -T postgres psql -U postgres -d velpdevdb -f /data/analyze-performance.sql

\echo '=========================================='
\echo 'VelPharma Database Performance Analysis'
\echo '=========================================='
\echo ''

-- Record counts
\echo '📊 Table Record Counts:'
SELECT
    schemaname,
    tablename,
    n_live_tup as row_count,
    n_dead_tup as dead_rows,
    last_autovacuum,
    last_autoanalyze
FROM pg_stat_user_tables
WHERE schemaname = 'vpv4'
ORDER BY n_live_tup DESC;

\echo ''
\echo '🔍 Missing Indexes (tables with seq scans but no index scans):'
SELECT
    schemaname,
    tablename,
    seq_scan,
    seq_tup_read,
    idx_scan,
    seq_tup_read / NULLIF(seq_scan, 0) as avg_rows_per_seq_scan
FROM pg_stat_user_tables
WHERE schemaname = 'vpv4'
  AND seq_scan > 0
  AND (idx_scan IS NULL OR idx_scan = 0)
  AND seq_tup_read > 1000
ORDER BY seq_tup_read DESC;

\echo ''
\echo '⚠️  Bloated Tables (needing VACUUM):'
SELECT
    schemaname,
    tablename,
    n_dead_tup as dead_tuples,
    n_live_tup as live_tuples,
    round(100.0 * n_dead_tup / NULLIF(n_live_tup + n_dead_tup, 0), 2) as bloat_ratio
FROM pg_stat_user_tables
WHERE schemaname = 'vpv4'
  AND n_dead_tup > 1000
ORDER BY n_dead_tup DESC;

\echo ''
\echo '🔐 Lock Monitoring:'
SELECT
    l.locktype,
    l.mode,
    l.granted,
    a.query_start,
    now() - a.query_start as duration,
    left(a.query, 100) as query
FROM pg_locks l
JOIN pg_stat_activity a ON l.pid = a.pid
WHERE a.datname = 'velpdevdb'
  AND a.query NOT ILIKE '%pg_stat_activity%'
ORDER BY duration DESC;

\echo ''
\echo '🎯 Query Performance (slowest queries):'
SELECT
    calls,
    total_exec_time::numeric(10,2) as total_time_ms,
    mean_exec_time::numeric(10,2) as avg_time_ms,
    max_exec_time::numeric(10,2) as max_time_ms,
    left(query, 100) as query
FROM pg_stat_statements
WHERE query NOT ILIKE '%pg_stat%'
ORDER BY mean_exec_time DESC
LIMIT 10;

\echo ''
\echo '=========================================='
\echo '💡 Recommendations:'
\echo '  1. Run ANALYZE on tables with high seq_scan'
\echo '  2. Consider adding indexes for sequential scans'
\echo '  3. VACUUM tables with high bloat ratio'
\echo '  4. Optimize slow queries'
\echo '=========================================='
