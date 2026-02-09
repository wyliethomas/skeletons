#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails
rm -f /app/tmp/pids/server.pid

# Wait for database to be ready
echo "Waiting for database..."
until pg_isready -h $DATABASE_HOST -U ${DATABASE_USERNAME:-postgres} -q; do
  sleep 1
done
echo "Database is ready!"

# Then exec the container's main process (what's set as CMD in the Dockerfile)
exec "$@"
