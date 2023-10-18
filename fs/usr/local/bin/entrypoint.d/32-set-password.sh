#!/usr/bin/env bash

# Set user password
  if [[ -n ${IDE_PASSWORD} ]]; then
    echo "Using provided IDE_PASSWORD for user."
  else
    IDE_PASSWORD=$(C_ALL=C tr -dc A-Za-z0-9 </dev/urandom | head -c 12)
    echo "Setting user IDE_PASSWORD to ${IDE_PASSWORD}... Remember, this changes every time container is started."
  fi
  sudo echo "${USERNAME}:${IDE_PASSWORD}" | sudo chpasswd
