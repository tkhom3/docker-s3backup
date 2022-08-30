FROM alpine:3.16.2

RUN apk update && apk add --no-cache \
  bash=5.1.16 \
  py3-pip=22.2.2 \
  python3=3.10.6 \
  py3-magic=0.4.24 \
  py3-dateutil=2.8.2

COPY requirements.txt /
COPY s3cmd.cfg /root/.s3cfg
COPY run.sh /

RUN ["chmod", "+x", "/run.sh"]

RUN pip install -r /requirements.txt && \
  rm -rf /tmp/pip_build_root/

RUN mkdir -p /backup

ENTRYPOINT ["/run.sh"]
CMD ["start"]
