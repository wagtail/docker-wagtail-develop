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

echo Starting a vagrant machine...
vagrant up
