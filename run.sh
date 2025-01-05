#!/bin/sh

if [ ! -e "$APP_DIR/$LOG_FILE" ]; then
  touch "$APP_DIR/$LOG_FILE"
fi

if [ ! -e "$APP_DIR/$CACHE_FILE" ]; then
  touch "$APP_DIR/$CACHE_FILE"
fi

if [ -f "crontab" ]; then
  rm "crontab"
fi

if grep -Fq "$ACCESS_KEY" "s3cmd.cfg"; then
  echo "ACCESS_KEY already exists in s3cmd.cfg"
else
  sed -i 's@access_key =@access_key = '"$ACCESS_KEY"'@g' "s3cmd.cfg"
fi

if grep -Fq "$SECRET_KEY" "s3cmd.cfg"; then
  echo "SECRET_KEY already exists in s3cmd.cfg"
else
  sed -i 's@secret_key =@secret_key = '"$SECRET_KEY"'@g' "s3cmd.cfg"
fi

if grep -Fq "$APP_DIR/$CACHE_FILE" "s3cmd.cfg"; then
  echo "CACHE_FILE already exists in s3cmd.cfg"
else
  sed -i 's@cache_file =@cache_file = '"$APP_DIR/$CACHE_FILE"'@g' "s3cmd.cfg"
fi

if grep -Fq "verbosity = $LOG_LEVEL" "s3cmd.cfg"; then
  echo "LOG_LEVEL already exists in s3cmd.cfg"
else
  sed -i 's@verbosity =@verbosity = '"$LOG_LEVEL"'@g' "s3cmd.cfg"
fi

echo
echo "----------------------------------------"
echo "Found the following directories to sync:"
ls -F $BACKUP_DIR
echo "----------------------------------------"

echo "$CRON_SCHEDULE s3cmd sync -c /home/$USER_NAME/s3cmd.cfg --cache-file=$APP_DIR/$CACHE_FILE $BACKUP_DIR/ $S3PATH" >> "/home/$USER_NAME/crontab"
# supercronic -split-logs -debug crontab 1>$APP_DIR/$LOG_FILE
supercronic -debug crontab
