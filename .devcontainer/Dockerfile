FROM mcr.microsoft.com/devcontainers/python:3.13-bookworm

ENV PYTHONUNBUFFERED=1

# Install additional OS packages
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    s3cmd \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Create the workspace directory
WORKDIR /workspaces/docker-s3backup

# Switch to non-root user
USER vscode
