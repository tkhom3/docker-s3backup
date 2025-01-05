FROM python:3.12.8-slim

ARG USER=root
ARG GROUP=root

ENV APP_DIR="/s3backup"
ENV BACKUP_DIR="/backup"
ENV ACCESS_KEY=
ENV SECRET_KEY=
ENV S3PATH=
ENV CRON_SCHEDULE="0 3 * * 6"
ENV LOG_LEVEL="INFO"
ENV CACHE_FILE="s3cmd_cache.txt"
ENV LOG_FILE="s3backup.log"

RUN mkdir $APP_DIR $BACKUP_DIR && \
    chown $USER:$GROUP $APP_DIR $BACKUP_DIR && \
    chmod 400 $BACKUP_DIR && \
    chmod 600 $APP_DIR

WORKDIR $APP_DIR

COPY --chown=$USER:$GROUP s3cmd.cfg .
COPY --chown=$USER:$GROUP run.sh .

RUN chmod 500 run.sh && \
    chmod 600 s3cmd.cfg

COPY requirements.txt /tmp/
RUN pip install --requirement /tmp/requirements.txt

ENTRYPOINT ["sh", "run.sh"]
CMD ["start"]
