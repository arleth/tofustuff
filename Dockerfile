# Use the official PostgreSQL 17 Alpine image for smaller size
FROM postgres:17-alpine

# Install additional tools
RUN apk add --no-cache gzip curl

# Copy initialization scripts (schema only)
COPY ./init/*.sql /docker-entrypoint-initdb.d/

# Set default environment
ENV POSTGRES_DB=velpdevdb
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=changeme

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD pg_isready -U postgres || exit 1

# Labels for metadata
LABEL maintainer="VelPharma Team"
LABEL version="1.0.0"
LABEL description="VelPharma Drug Database - Schema Only"