#!/bin/sh

if [ ! -e "$APP_DIR/$LOG_FILE" ]; then
  touch "$APP_DIR/$LOG_FILE"
fi

if [ ! -e "$APP_DIR/$CACHE_FILE" ]; then
  touch "$APP_DIR/$CACHE_FILE"
fi

if [ -f "$APP_DIR/crontab" ]; then
  rm "$APP_DIR/crontab"
fi

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

echo
echo "----------------------------------------"
echo "Found the following directories to sync:"
ls -F $BACKUP_DIR
echo "----------------------------------------"

echo "$CRON_SCHEDULE s3cmd sync -c $APP_DIR/s3cmd.cfg --cache-file=$APP_DIR/$CACHE_FILE $BACKUP_DIR/ $S3PATH" >> "$APP_DIR/crontab"
# supercronic -split-logs -debug crontab 1>$APP_DIR/$LOG_FILE
supercronic -debug crontab
