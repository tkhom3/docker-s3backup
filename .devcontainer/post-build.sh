#!/bin/sh

curl -sSL https://install.python-poetry.org | python3 -
poetry config virtualenvs.create false
poetry install --no-interaction --no-ansi --no-root
