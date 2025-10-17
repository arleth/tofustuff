-- Install PostgreSQL extensions
-- This script runs automatically when the container is first created

\c velpdevdb;

-- Create extensions commonly used in the application
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";      -- UUID generation functions
CREATE EXTENSION IF NOT EXISTS "pgcrypto";       -- Cryptographic functions
CREATE EXTENSION IF NOT EXISTS "pg_trgm";        -- Text similarity & fuzzy search
CREATE EXTENSION IF NOT EXISTS "unaccent";       -- Remove accents from text
CREATE EXTENSION IF NOT EXISTS "hstore";         -- Key-value store

-- Performance monitoring extensions
CREATE EXTENSION IF NOT EXISTS "pg_stat_statements";  -- Query performance tracking
-- Note: system_stats extension skipped (not critical, only used for PgAdmin dashboard)

-- Additional useful extensions (if available)
CREATE EXTENSION IF NOT EXISTS "btree_gin";      -- GIN indexes for scalar types
CREATE EXTENSION IF NOT EXISTS "btree_gist";     -- GiST indexes for scalar types

-- Log successful extension creation
DO $$
BEGIN
    RAISE NOTICE 'VelPharma database extensions created successfully';
END
$$;