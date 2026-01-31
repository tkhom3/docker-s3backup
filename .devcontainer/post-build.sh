#!/bin/sh

set -e

pip install poetry

# Configure Poetry and install dependencies
poetry config virtualenvs.create false
poetry install
