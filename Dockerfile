FROM python:3.12.8-alpine3.21

ARG USER_NAME=s3backup
ARG GROUP=s3backup

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

RUN useradd -m $USER_NAME

RUN chown $USER_NAME:$GROUP $APP_DIR $BACKUP_DIR && \
    chmod 440 $BACKUP_DIR && \
    chmod 770 $APP_DIR

WORKDIR /home/$USER_NAME

COPY --chown=$USER_NAME:$GROUP s3cmd.cfg .
COPY --chown=$USER_NAME:$GROUP run.sh .

RUN chmod 554 run.sh && \
    chmod 664 s3cmd.cfg

COPY requirements.txt .
RUN pip install -r requirements.txt

USER $USER_NAME

# ENTRYPOINT ["sh", "run.sh"]
ENTRYPOINT ["tail", "-f", "/dev/null"]