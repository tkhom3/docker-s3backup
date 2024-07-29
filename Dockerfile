FROM alpine:3.20.2

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
    bash==5.2.26-r0 \
    python3==3.12.3-r1 \
    py3-magic==0.4.27-r3 \
    py3-dateutil==2.9.0-r1 \
    s3cmd==2.4.0-r1 \
    --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community

RUN mkdir /config /backup && \
    chown $USER:$GROUP /config /backup && \
    chmod 400 /backup && \
    chmod 600 /config

WORKDIR $HOME

COPY --chown=$USER:$GROUP s3cmd.cfg .
COPY --chown=$USER:$GROUP run.sh .

RUN chmod 500 run.sh && \
    chmod 600 s3cmd.cfg

ENTRYPOINT ["sh", "run.sh"]
CMD ["start"]
