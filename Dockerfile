FROM python:3.12.8-alpine3.21

ARG USER=s3backup
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

RUN useradd -m $USER

RUN mkdir $APP_DIR $BACKUP_DIR && \
    chown $USER:$GROUP $APP_DIR $BACKUP_DIR && \
    chmod 440 $BACKUP_DIR && \
    chmod 770 $APP_DIR

WORKDIR $APP_DIR

COPY --chown=$USER:$GROUP s3cmd.cfg .
COPY --chown=$USER:$GROUP run.sh .

RUN chmod 554 run.sh && \
    chmod 664 s3cmd.cfg

COPY requirements.txt /tmp/
RUN pip install --requirement /tmp/requirements.txt

USER $USER

ENTRYPOINT ["sh", "run.sh"]
