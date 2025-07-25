FROM python:3.13.5-alpine3.21

ENV USER="s3backup"
ENV UID="99"
ENV GID="100"
ENV APP_DIR="/s3backup"
ENV BACKUP_DIR="/backup"
ENV ACCESS_KEY=
ENV SECRET_KEY=
ENV S3PATH=
ENV CRON_SCHEDULE="0 3 * * 6"
ENV LOG_LEVEL="INFO"
ENV CACHE_FILE="s3cmd_cache.txt"
ENV LOG_FILE="s3backup.log"

RUN apk update && apk add --no-cache \
    supercronic \
    shadow

RUN useradd -m $USER

WORKDIR /tmp

COPY init-update-user.sh .
RUN chmod 500 init-update-user.sh && \
    ./init-update-user.sh && \
    rm init-update-user.sh

WORKDIR /home/$USER

COPY --chown=$USER:$USER s3cmd.cfg .
COPY --chown=$USER:$USER run.sh .
RUN chmod 554 run.sh && \
    chmod 664 s3cmd.cfg

COPY requirements.txt .
RUN pip install -r requirements.txt

USER $USER

ENTRYPOINT ["sh", "run.sh"]
