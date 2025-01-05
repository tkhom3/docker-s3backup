#!/bin/sh

OPTION="$1"
LOCKFILE="/tmp/s3cmd.lock"

# Cleanup file on exit
trap 'rm -f "$LOCKFILE"' EXIT

if [ ! -e "$APP_DIR/$LOG_FILE" ]; then
  touch "$APP_DIR/$LOG_FILE"
fi

if [ ! -e "$APP_DIR/$CACHE_FILE" ]; then
  touch "$APP_DIR/$CACHE_FILE"
fi

if [[ "$OPTION" = "start" ]]; then
  echo "Found the following files to sync:"
  echo
  ls -F $BACKUP_DIR
  echo

  if grep -Fq "$ACCESS_KEY" "$APP_DIR/s3cmd.cfg"; then
    echo "ACCESS_KEY already exists in $APP_DIR/s3cmd.cfg"
  else
    sed -i 's@access_key =@access_key = '"$ACCESS_KEY"'@g' "$APP_DIR/s3cmd.cfg"
  fi
  
  if grep -Fq "$SECRET_KEY" "$APP_DIR/s3cmd.cfg"; then
    echo "SECRET_KEY already exists in $APP_DIR/s3cmd.cfg"
  else
    sed -i 's@secret_key =@secret_key = '"$SECRET_KEY"'@g' "$APP_DIR/s3cmd.cfg"
  fi

  if grep -Fq "$APP_DIR/$CACHE_FILE" "$APP_DIR/s3cmd.cfg"; then
    echo "CACHE_FILE already exists in $APP_DIR/s3cmd.cfg"
  else
    sed -i 's@cache_file =@cache_file = '"$APP_DIR/$CACHE_FILE"'@g' "$APP_DIR/s3cmd.cfg"
  fi

  if grep -Fq "verbosity = $LOG_LEVEL" "$APP_DIR/s3cmd.cfg"; then
    echo "LOG_LEVEL already exists in $APP_DIR/s3cmd.cfg"
  else
    sed -i 's@verbosity =@verbosity = '"$LOG_LEVEL"'@g' "$APP_DIR/s3cmd.cfg"
  fi


  echo "Running backup on the following CRON schedule: $CRON_SCHEDULE"
  echo "$CRON_SCHEDULE sh tmp/run.sh backup" | crontab - && crond -f -L /dev/stdout

elif [[ "$OPTION" = "backup" ]]; then
  echo "Starting sync: $(date)" | tee -a "$APP_DIR/$LOG_FILE"

  if [ -f "$LOCKFILE" ]; then
    echo "$LOCKFILE detected, exiting! Already running?" | tee -a "$APP_DIR/$LOG_FILE"
    exit 1
  else
    touch "$LOCKFILE"
  fi

  echo "Executing s3cmd sync -c $APP_DIR/s3cmd.cfg $S3CMDPARAMS $BACKUP_DIR/ $S3PATH" | tee -a "$APP_DIR/$LOG_FILE"
  s3cmd sync -c "$APP_DIR/s3cmd.cfg" "$S3CMDPARAMS" $BACKUP_DIR/ "$S3PATH" 2>&1 | tee -a "$APP_DIR/$LOG_FILE"
  rm -f "$LOCKFILE"
  echo "Finished sync: $(date)" | tee -a "$APP_DIR/$LOG_FILE"

else
  echo "Unsupported option: $OPTION" | tee -a "$APP_DIR/$LOG_FILE"
  exit 1
fi
