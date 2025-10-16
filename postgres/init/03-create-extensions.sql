-- Install PostgreSQL extensions
-- This script runs automatically when the container is first created

\c velpdevdb;

-- Create extensions commonly used in the application
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";  -- For text search
CREATE EXTENSION IF NOT EXISTS "unaccent"; -- For text normalization

-- Performance monitoring extension
CREATE EXTENSION IF NOT EXISTS "pg_stat_statements";

-- Log successful extension creation
DO $$
BEGIN
    RAISE NOTICE 'VelPharma database extensions created successfully';
END
$$;