FROM alpine:3.16.1

RUN apk update && \
  apk add --no-cache \
  bash \
  py3-pip \
  python3 \
  py3-magic \
  py3-dateutil

ADD requirements.txt /
ADD s3cmd.cfg /root/.s3cfg
ADD run.sh /

RUN ["chmod", "+x", "/run.sh"]

RUN pip install -r /requirements.txt && \
  rm -rf /tmp/pip_build_root/

RUN mkdir -p /backup

ENTRYPOINT ["/run.sh"]
CMD ["start"]
