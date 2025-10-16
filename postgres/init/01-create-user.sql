-- Create VelPharma database user
-- This script runs automatically when the container is first created

-- Create the velpharma user if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'velpharma') THEN
        CREATE ROLE velpharma WITH LOGIN PASSWORD 'velpharma';
    END IF;
END
$$;

-- Grant necessary privileges
ALTER ROLE velpharma CREATEDB;
GRANT ALL PRIVILEGES ON DATABASE velpdevdb TO velpharma;

CREATE SCHEMA vpv4;

GRANT velpharma TO current_user;
ALTER SCHEMA vpv4 OWNER TO velpharma;
-- Grant usage on the schema
GRANT USAGE ON SCHEMA vpv4 TO velpharma;

-- Grant privileges on all tables in the schema
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA vpv4 TO velpharma;

-- Optionally, grant privileges on future tables in the schema
ALTER DEFAULT PRIVILEGES IN SCHEMA vpv4 GRANT ALL PRIVILEGES ON TABLES TO velpharma;
