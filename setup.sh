#!/usr/bin/env bash

# Fail if any command fails.
set -e

if [ ! -d "bakerydemo" ]; then
    git clone https://github.com/wagtail/bakerydemo.git
else
    echo Directory bakerydemo already exists, skipping...
fi


if [ ! -d "wagtail" ]; then
    git clone https://github.com/wagtail/wagtail.git
else
    echo Directory wagtail already exists, skipping...
fi


mkdir -p libs


if [ ! -d "libs/django-modelcluster" ]; then
    git clone https://github.com/wagtail/django-modelcluster.git libs/django-modelcluster
else
    echo Directory libs/django-modelcluster already exists, skipping...
fi


if [ ! -d "libs/Willow" ]; then
    git clone https://github.com/wagtail/Willow.git libs/Willow
else
    echo Directory libs/Willow already exists, skipping...
fi


# Set up bakerydemo to use the Postgres database in the sister container
if [ ! -f bakerydemo/bakerydemo/settings/local.py ]; then
    echo "Creating local settings file"
    cp bakerydemo-settings-local.py.example bakerydemo/bakerydemo/settings/local.py
fi

# Create a blank .env file in bakerydemo to keep its settings files from complaining
if [ ! -f bakerydemo/.env ]; then
    echo "Creating file for local environment variables"
    echo "DJANGO_SETTINGS_MODULE=bakerydemo.settings.local" > bakerydemo/.env
fi
