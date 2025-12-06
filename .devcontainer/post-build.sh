#!/bin/sh

set -e

pip install poetry

#Install Git
apk add --no-cache git

# Add Poetry to PATH
export PATH="/root/.local/bin:$PATH"

# Configure Poetry and install dependencies
poetry config virtualenvs.create false
poetry install --no-interaction --no-ansi
