FROM alpine:3.19.0

ARG USER=root
ARG GROUP=root

ENV HOME=/$USER
ENV ACCESS_KEY=
ENV SECRET_KEY=
ENV S3PATH=
ENV CRON_SCHEDULE="0 3 * * 6"
ENV LOG_LEVEL="INFO"
ENV CACHE_FILE="/tmp/s3cmd_cache.txt"
ENV LOG_FILE="/tmp/s3backup.log"

RUN apk update && apk add --no-cache \
    bash \
    py3-pip \
    python3 \
    py3-magic \
    py3-dateutil

RUN mkdir /config /backup && \
    chown $USER:$GROUP /config /backup && \
    chmod 400 /backup && \
    chmod 600 /config

WORKDIR $HOME

COPY --chown=$USER:$GROUP requirements.txt .
COPY --chown=$USER:$GROUP s3cmd.cfg .
COPY --chown=$USER:$GROUP run.sh .

RUN chmod 400 requirements.txt && \
    chmod 500 run.sh && \
    chmod 600 s3cmd.cfg

RUN pip install -r requirements.txt --no-cache-dir

ENTRYPOINT ["sh", "run.sh"]
CMD ["start"]
