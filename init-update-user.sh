#!/bin/sh

# Setup user/group ids for unraid
if [ ! -z $UID ]; then
  if [ ! "$(id -u $USER)" -eq $UID ]; then
    usermod -o -u $UID $USER
  fi
fi

if [ ! -z $GID ]; then
  if [ ! "$(id -g $USER)" -eq $GID ]; then
    groupmod -o -g $GID $USER
  fi
fi