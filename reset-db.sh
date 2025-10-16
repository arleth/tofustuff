#!/bin/bash
# Reset and rebuild the database with fresh init scripts

echo "🗑️  Stopping containers and removing volumes..."
docker compose down -v

echo "🔨 Rebuilding images..."
docker compose build --no-cache postgres

echo "🚀 Starting services with fresh database..."
docker compose up -d

echo "⏳ Waiting for database to be ready..."
sleep 5

echo "✅ Database reset complete!"
echo ""
echo "📊 Check status:"
echo "   docker compose ps"
echo ""
echo "📝 View logs:"
echo "   docker compose logs -f postgres"
echo ""
echo "🔗 Connect at: postgresql://postgres:changeme@localhost:5434/velpdevdb"
echo "🌐 PgAdmin at: http://localhost:5050"
