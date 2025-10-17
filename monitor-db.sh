#!/bin/bash
# Database monitoring script for VelPharma

echo "============================================"
echo "VelPharma Database Monitor"
echo "============================================"
echo ""

# Container stats
echo "📊 Container Resource Usage:"
docker stats --no-stream velpharma-db --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}\t{{.NetIO}}\t{{.BlockIO}}"
echo ""

# Database connections
echo "🔌 Active Connections:"
docker compose exec -T postgres psql -U postgres -d velpdevdb -c "
SELECT
    count(*) as total_connections,
    count(*) FILTER (WHERE state = 'active') as active,
    count(*) FILTER (WHERE state = 'idle') as idle,
    count(*) FILTER (WHERE state = 'idle in transaction') as idle_in_transaction
FROM pg_stat_activity
WHERE datname = 'velpdevdb';
" 2>/dev/null
echo ""

# Table sizes
echo "💾 Table Sizes:"
docker compose exec -T postgres psql -U postgres -d velpdevdb -c "
SELECT
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size,
    pg_total_relation_size(schemaname||'.'||tablename) as raw_size
FROM pg_tables
WHERE schemaname = 'vpv4'
ORDER BY raw_size DESC
LIMIT 15;
" 2>/dev/null
echo ""

# Current queries
echo "⚡ Current Long-Running Queries (>1s):"
docker compose exec -T postgres psql -U postgres -d velpdevdb -c "
SELECT
    pid,
    now() - pg_stat_activity.query_start AS duration,
    state,
    left(query, 80) as query
FROM pg_stat_activity
WHERE state != 'idle'
  AND query NOT ILIKE '%pg_stat_activity%'
  AND (now() - pg_stat_activity.query_start) > interval '1 seconds'
ORDER BY duration DESC;
" 2>/dev/null
echo ""

# Index usage
echo "📑 Index Usage Statistics:"
docker compose exec -T postgres psql -U postgres -d velpdevdb -c "
SELECT
    schemaname,
    tablename,
    indexname,
    idx_scan as index_scans,
    pg_size_pretty(pg_relation_size(indexrelid)) as index_size
FROM pg_stat_user_indexes
WHERE schemaname = 'vpv4'
ORDER BY idx_scan ASC
LIMIT 10;
" 2>/dev/null
echo ""

# Cache hit ratio
echo "🎯 Cache Hit Ratio (should be >90%):"
docker compose exec -T postgres psql -U postgres -d velpdevdb -c "
SELECT
    sum(heap_blks_read) as heap_read,
    sum(heap_blks_hit) as heap_hit,
    round(100 * sum(heap_blks_hit) / NULLIF(sum(heap_blks_hit) + sum(heap_blks_read), 0), 2) AS cache_hit_ratio
FROM pg_statio_user_tables;
" 2>/dev/null
echo ""

echo "============================================"
echo "💡 Tips:"
echo "  - Cache hit ratio should be >90%"
echo "  - Watch for idle in transaction connections"
echo "  - Check long-running queries"
echo "  - Monitor memory usage vs limits"
echo "============================================"
