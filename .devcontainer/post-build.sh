#!/bin/sh

set -e

curl -sSL https://install.python-poetry.org | python3 -

#Install Git
apk add --no-cache git

# Add Poetry to PATH
export PATH="/root/.local/bin:$PATH"

# Configure Poetry and install dependencies
poetry config virtualenvs.create false
poetry install
