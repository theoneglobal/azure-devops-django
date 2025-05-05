#!/bin/bash

set -e

# Set Django settings module to use override.py directly
export DJANGO_SETTINGS_MODULE=azuredjango.settings.override

MIGRATIONS_DIR="/home/docker/app/azuredjango/migrations"
HASH_FILE="/home/docker/app/migrations_hash"
CURRENT_HASH=$(find "$MIGRATIONS_DIR" -type f -name '*.py' -exec sha256sum {} + | sort | sha256sum | cut -d ' ' -f1)

if [ ! -f "$HASH_FILE" ] || [ "$CURRENT_HASH" != "$(cat $HASH_FILE)" ]; then
    echo "🛠️ New migrations detected, applying..."
    poetry run python manage.py migrate --noinput
    echo "$CURRENT_HASH" > "$HASH_FILE"
else
    echo "✅ Migrations already up to date, skipping."
fi

echo "🎨 Collecting static files..."
poetry run python manage.py collectstatic --noinput

echo "🚀 Starting Gunicorn..."
exec poetry run gunicorn --bind 0.0.0.0:8000 azuredjango.wsgi:application
