#!/usr/bin/env bash

sudo ssh-keygen -A

if [[ -n ${PASSWORD} ]]; then
  echo "Using provided password for user."
else
  PASSWORD=$(C_ALL=C tr -dc A-Za-z0-9 </dev/urandom | head -c 12)
  echo "Setting user php-ide's password to ${PASSWORD}... Remember, this changes every time container is started."
fi

sudo echo "vscode:${PASSWORD}" | sudo chpasswd
sudo mkdir /run/sshd

if [[ -n ${SSH-KEY} ]]; then
  sudo echo "${SSH-KEY}" > /home/vscode/.ssh/authorized_keys
  sudo chown vscode:vscode /home/vscode/.ssh/authorized_keys
  sudo chmod 600 /home/vscode/.ssh/authorized_keys
fi

# Run any custom startup scripts
if [[ -f $PWD/start.sh ]]; then
  chmod +x $PWD/start.sh
  $PWD/start.sh
fi

# Run the command passed to the container
exec "$@"