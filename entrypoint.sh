#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /backend/tmp/pids/server.pid
# Check if the database exists
if bundle exec rails db:version; then
  echo "Database already exists. Running migrations..."
  bundle exec rails db:migrate
else
  echo "Database does not exist. Creating and migrating..."
  bundle exec rails db:create
  bundle exec rails db:migrate
  bundle exec rails db:seed
fi
# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"