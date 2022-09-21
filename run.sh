#!/bin/sh

# Set sane bash defaults
# set -o errexit
# set -o pipefail

HOME="$1"
OPTION="$2"
ACCESS_KEY=${ACCESS_KEY:?"ACCESS_KEY required"}
SECRET_KEY=${SECRET_KEY:?"SECRET_KEY required"}
S3PATH=${S3PATH:?"S3_PATH required"}
CRON_SCHEDULE=${CRON_SCHEDULE:-0 3 * * 6}

LOCKFILE="$HOME/s3cmd.lock"
LOG="/config/s3backup.log"
CACHE="/config/s3cmd_cache.txt"

# Cleanup file on exit
trap 'rm -f $LOCKFILE' EXIT

if [ ! -e $LOG ]; then
  touch $LOG
fi

if [ ! -e $CACHE ]; then
  touch $CACHE
fi

if [[ $OPTION = "start" ]]; then
  echo "Found the following files to sync:"
  echo
  ls -F /backup
  echo

  if grep -Fq "$ACCESS_KEY" $HOME/s3cmd.cfg; then
    echo "ACCESS_KEY already exists in $HOME/s3cmd.cfg"
  else
    sed -i 's@access_key =@access_key = '"$ACCESS_KEY"'@g' $HOME/s3cmd.cfg
  fi
  
  if grep -Fq "$SECRET_KEY" $HOME/s3cmd.cfg; then
    echo "SECRET_KEY already exists in $HOME/s3cmd.cfg"
  else
    sed -i 's@secret_key =@secret_key = '"$SECRET_KEY"'@g' $HOME/s3cmd.cfg
  fi

  chmod 600 $HOME/s3cmd.cfg

  echo "Running backup on the following CRON schedule: $CRON_SCHEDULE"
  echo "$CRON_SCHEDULE sh /run.sh backup" | crontab - && crond -f -L /dev/stdout

elif [[ $OPTION = "backup" ]]; then
  echo "Starting sync: $(date)" | tee $LOG

  if [ -f $LOCKFILE ]; then
    echo "$LOCKFILE detected, exiting! Already running?" | tee -a $LOG
    exit 1
  else
    touch $LOCKFILE
  fi

  echo "Executing s3cmd sync -c $HOME/s3cmd.cfg $S3CMDPARAMS /backup/ $S3PATH" | tee -a $LOG
  s3cmd sync -c $HOME/s3cmd.cfg $S3CMDPARAMS /backup/ $S3PATH 2>&1 | tee -a $LOG
  rm -f $LOCKFILE
  echo "Finished sync: $(date)" | tee -a $LOG

else
  echo "Unsupported option: $OPTION" | tee -a $LOG
  exit 1
fi
