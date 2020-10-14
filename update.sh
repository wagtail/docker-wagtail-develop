#!/usr/bin/env bash

set -e

CURRENT_DIR=$PWD

echo "Updating bakerydemo"
cd $CURRENT_DIR/bakerydemo && git pull --rebase

echo "Updating wagtail"
cd $CURRENT_DIR/wagtail && git pull --rebase

echo "Updating django-modelcluster"
cd $CURRENT_DIR/libs/django-modelcluster && git pull --rebase

echo "Updating Willow"
cd $CURRENT_DIR/libs/Willow && git pull --rebase
