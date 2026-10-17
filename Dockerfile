FROM python:3.14.8-alpine3.23

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

ENV USER="s3backup"
ENV UID="99"
ENV GID="100"
ENV APP_DIR="/s3backup"
ENV BACKUP_DIR="/backup"
ENV PHOTO_DIR="/backup-photos"
ENV ACCESS_KEY=
ENV SECRET_KEY=
ENV S3PATH=
ENV CRON_SCHEDULE=
ENV PHOTO_CRON_SCHEDULE=
ENV LOG_LEVEL="INFO"
ENV CACHE_FILE="s3cmd_cache.txt"
ENV LOG_FILE="s3backup.log"

RUN apk update && apk add --no-cache \
    supercronic \
    shadow \
    curl

RUN useradd -m $USER

WORKDIR /tmp

COPY init-update-user.sh .
RUN chmod 500 init-update-user.sh && \
    ./init-update-user.sh && \
    rm init-update-user.sh

WORKDIR /home/$USER

COPY --chown=$USER:$USER s3cmd.cfg .
COPY --chown=$USER:$USER run.sh .

COPY pyproject.toml uv.lock ./
RUN pip install --no-cache-dir uv

USER $USER
RUN uv sync --locked --no-dev --no-install-project

ENV PATH="/home/$USER/.venv/bin:$PATH"

COPY --chown=$USER:$USER s3cmd.cfg run.sh ./
RUN chmod 554 run.sh && chmod 664 s3cmd.cfg

ENTRYPOINT ["sh", "run.sh"]
