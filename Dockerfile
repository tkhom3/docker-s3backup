FROM alpine:3.16.2

ARG USER=root
ARG GROUP=root
ARG HOME=/$USER

RUN apk update && apk add --no-cache \
    bash=5.1.16-r2 \
    py3-pip=22.1.1-r0 \
    python3=3.10.5-r0 \
    py3-magic=0.4.24-r1 \
    py3-dateutil=2.8.2-r1

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
CMD ["$HOME", "start"]
