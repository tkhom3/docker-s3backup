#!/bin/sh

OPTION="$1"
LOCKFILE="$HOME/s3cmd.lock"

# Cleanup file on exit
trap 'rm -f "$LOCKFILE"' EXIT

if [ ! -e "$LOG_FILE" ]; then
  touch "$LOG_FILE"
fi

if [[ "$OPTION" = "start" ]]; then
  echo "Found the following files to sync:"
  echo
  ls -F /backup
  echo

  if grep -Fq "$ACCESS_KEY" "$HOME/s3cmd.cfg"; then
    echo "ACCESS_KEY already exists in $HOME/s3cmd.cfg"
  else
    sed -i 's@access_key =@access_key = '"$ACCESS_KEY"'@g' "$HOME/s3cmd.cfg"
  fi
  
  if grep -Fq "$SECRET_KEY" "$HOME/s3cmd.cfg"; then
    echo "SECRET_KEY already exists in $HOME/s3cmd.cfg"
  else
    sed -i 's@secret_key =@secret_key = '"$SECRET_KEY"'@g' "$HOME/s3cmd.cfg"
  fi

  if grep -Fq "$CACHE_FILE" "$HOME/s3cmd.cfg"; then
    echo "CACHE_FILE already exists in $HOME/s3cmd.cfg"
  else
    sed -i 's@cache_file =@cache_file = '"$CACHE_FILE"'@g' "$HOME/s3cmd.cfg"
  fi

  if grep -Fq "verbosity = $LOG_LEVEL" "$HOME/s3cmd.cfg"; then
    echo "LOG_LEVEL already exists in $HOME/s3cmd.cfg"
  else
    sed -i 's@verbosity =@verbosity = '"$LOG_LEVEL"'@g' "$HOME/s3cmd.cfg"
  fi


  echo "Running backup on the following CRON schedule: $CRON_SCHEDULE"
  echo "$CRON_SCHEDULE sh $HOME/run.sh backup" | crontab - && crond -f -L /dev/stdout

elif [[ "$OPTION" = "backup" ]]; then
  echo "Starting sync: $(date)" | tee "$LOG_FILE"

  if [ -f "$LOCKFILE" ]; then
    echo "$LOCKFILE detected, exiting! Already running?" | tee -a "$LOG_FILE"
    exit 1
  else
    touch "$LOCKFILE"
  fi

  echo "Executing s3cmd sync -c $HOME/s3cmd.cfg $S3CMDPARAMS /backup/ $S3PATH" | tee -a "$LOG_FILE"
  s3cmd sync -c "$HOME/s3cmd.cfg" "$S3CMDPARAMS" /backup/ "$S3PATH" 2>&1 | tee -a "$LOG_FILE"
  rm -f "$LOCKFILE"
  echo "Finished sync: $(date)" | tee -a "$LOG_FILE"

else
  echo "Unsupported option: $OPTION" | tee -a "$LOG_FILE"
  exit 1
fi
