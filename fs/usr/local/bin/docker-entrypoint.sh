#!/usr/bin/env bash

# Run additional entrypoint scripts for runlevel 1, if any exist.
if [[ -d /usr/local/bin/entrypoint.d.1 ]]; then
  chmod +x /usr/local/bin/entrypoint.d.1/*.sh
  for f in /usr/local/bin/entrypoint.d.1/*.sh; do
    echo "Running $f"
    sudo $f
  done
fi

# Run any custom startup scripts in userspace
if [[ -f $PWD/setup.sh ]]; then
  chmod +x $PWD/setup.sh
  $PWD/start.sh
fi

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

# Run additional entrypoint scripts for runlevel 8, if any exist.
if [[ -d /usr/local/bin/entrypoint.d.8 ]]; then
  chmod +x /usr/local/bin/entrypoint.d.8/*.sh
  for f in /usr/local/bin/entrypoint.d.8/*.sh; do
    echo "Running $f"
    sudo $f
  done
fi

# Run any custom startup scripts in userspace
if [[ -f $PWD/start.sh ]]; then
  chmod +x $PWD/start.sh
  $PWD/start.sh
fi

# Run additional entrypoint scripts for runlevel 9, if any exist.
if [[ -d /usr/local/bin/entrypoint.d.9 ]]; then
  chmod +x /usr/local/bin/entrypoint.d.9/*.sh
  for f in /usr/local/bin/entrypoint.d.9/*.sh; do
    echo "Running $f"
    sudo $f
  done
fi

# Run the command passed to the container
exec "$@"