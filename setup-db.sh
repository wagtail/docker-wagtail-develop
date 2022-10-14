#!/usr/bin/env bash

# Fail if any command fails.
set -e

docker-compose exec web python manage.py migrate --noinput
docker-compose exec web python manage.py load_initial_data
docker-compose exec web python manage.py update_index
