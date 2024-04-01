FROM alpine:3.19.1

ARG USER=root
ARG GROUP=root

ENV HOME=/$USER
ENV ACCESS_KEY=
ENV SECRET_KEY=
ENV S3PATH=


RUN apk update && apk add --no-cache \
    bash==5.2.21-r0 \
    python3==3.11.6-r1 \
    py3-magic==0.4.27-r2 \
    py3-dateutil==2.8.2-r4 \
    s3cmd==2.4.0-r0 \
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
