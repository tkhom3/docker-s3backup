FROM alpine:3.16.2


ARG USER=test
# ARG HOME=/home/$USER
ENV HOME /home/$USER

RUN addgroup -S $USER && adduser -S $USER -G $USER

RUN apk update && apk add --no-cache \
    bash=5.1.16-r2 \
    py3-pip=22.1.1-r0 \
    python3=3.10.5-r0 \
    py3-magic=0.4.24-r1 \
    py3-dateutil=2.8.2-r1

WORKDIR $HOME

COPY requirements.txt .
COPY s3cmd.cfg .
COPY run.sh .

RUN chmod +x run.sh && \
    chown $USER:$USER * 

USER $USER

RUN pip install -r requirements.txt --no-cache-dir

VOLUME /config
VOLUME /backup

ENTRYPOINT ["sh", "run.sh"]
CMD [$HOME, "start"]
