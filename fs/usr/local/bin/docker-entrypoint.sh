#!/usr/bin/env bash

## RUNLEVEL 1 ##

  # Run additional entrypoint scripts at runlevel 1, if any exist.
  if [[ -d /usr/local/bin/entrypoint.d.1 ]]; then
    chmod +x /usr/local/bin/entrypoint.d.1/*.sh
    for f in /usr/local/bin/entrypoint.d.1/*.sh; do
      echo "Running $f"
      sudo $f
    done
  fi

## RUNLEVEL 2 ##

  # Run any custom startup scripts in userspace
  if [[ -f $PWD/setup.sh ]]; then
    chmod +x $PWD/setup.sh
    $PWD/start.sh
  fi

  # Run additional entrypoint scripts at runlevel 2, if any exist.
  if [[ -d /usr/local/bin/entrypoint.d.2 ]]; then
    chmod +x /usr/local/bin/entrypoint.d.2/*.sh
    for f in /usr/local/bin/entrypoint.d.2/*.sh; do
      echo "Running $f"
      sudo $f
    done
  fi

## RUNLEVEL 3 ##

  # Custom scripts at runlevel 3, if any exist.
  if [[ -d /usr/local/bin/entrypoint.d.3 ]]; then
    chmod +x /usr/local/bin/entrypoint.d.3/*.sh
    for f in /usr/local/bin/entrypoint.d.3/*.sh; do
      echo "Running $f"
      sudo $f
    done
  fi

## RUNLEVEL 4 ##

  # Setup sshd
  if [[ -d /usr/local/etc/ssh ]] && [[ "$( ls -A /usr/local/etc/ssh" ) ]]; then
    rm -r /etc/ssh
    ln -s /usr/local/etc/ssh /etc/ssh
  else
    mkdir -p /usr/local/etc/ssh
    sudo ssh-keygen -A
    mv /etc/ssh/* /usr/local/etc/ssh/
    rm -r /etc/ssh
    ln -s /usr/local/etc/ssh /etc/ssh
  fi
  [[ -d /run/sshd ]] || sudo mkdir /run/sshd

  # Custom RL4 scripts, if any exist.
  if [[ -d /usr/local/bin/entrypoint.d.4 ]]; then
    chmod +x /usr/local/bin/entrypoint.d.4/*.sh
    for f in /usr/local/bin/entrypoint.d.4/*.sh; do
      echo "Running $f"
      sudo $f
    done
  fi

## RUNLEVEL 5 ##

  # Set password for vscode user
  if [[ -n ${PASSWORD} ]]; then
    echo "Using provided password for user."
  else
    PASSWORD=$(C_ALL=C tr -dc A-Za-z0-9 </dev/urandom | head -c 12)
    echo "Setting user php-ide's password to ${PASSWORD}... Remember, this changes every time container is started."
  fi
  sudo echo "vscode:${PASSWORD}" | sudo chpasswd

  # Run additional entrypoint scripts for runlevel 5, if any exist.
  if [[ -d /usr/local/bin/entrypoint.d.5 ]]; then
    chmod +x /usr/local/bin/entrypoint.d.5/*.sh
    for f in /usr/local/bin/entrypoint.d.5/*.sh; do
      echo "Running $f"
      sudo $f
    done
  fi

## RUNLEVEL 6 ##

  # Build authorized-keys file for vscode user
  [[ -f /home/vscode/.ssh/authorized_keys ]] && rm /home/vscode/.ssh/authorized_keys

  if [[ -n ${SSH-KEY} ]]; then
    sudo echo "${SSH-KEY}" > /home/vscode/.ssh/authorized_keys
  fi

  if [[ -d /home/vscode/.ssh/authorized_keys.d ]]; then
    for key in /home/vscode/.ssh/authorized_keys.d/*.key; do
      cat $key >> /home/vscode/.ssh/authorized_keys
    done
  fi

  if [[ -d /home/vscode/.ssh/authorized_keys.user.d ]]; then
    for key in /home/vscode/.ssh/authorized_keys.user.d/*; do
      cat $key >> /home/vscode/.ssh/authorized_keys
    done
  fi

  # Set permissions on authorized_keys file
  sudo chown vscode:vscode /home/vscode/.ssh/authorized_keys
  sudo chmod 600 /home/vscode/.ssh/authorized_keys

  # Run additional entrypoint scripts for runlevel 6, if any exist.
  if [[ -d /usr/local/bin/entrypoint.d.6 ]]; then
    chmod +x /usr/local/bin/entrypoint.d.6/*.sh
    for f in /usr/local/bin/entrypoint.d.6/*.sh; do
      echo "Running $f"
      sudo $f
    done
  fi

## RUNLEVEL 7 ##

  # Run additional entrypoint scripts for runlevel 7, if any exist.
  if [[ -d /usr/local/bin/entrypoint.d.7 ]]; then
    chmod +x /usr/local/bin/entrypoint.d.7/*.sh
    for f in /usr/local/bin/entrypoint.d.7/*.sh; do
      echo "Running $f"
      sudo $f
    done
  fi

## RUNLEVEL 8 ##

  # Run additional entrypoint scripts for runlevel 8, if any exist.
  if [[ -d /usr/local/bin/entrypoint.d.8 ]]; then
    chmod +x /usr/local/bin/entrypoint.d.8/*.sh
    for f in /usr/local/bin/entrypoint.d.8/*.sh; do
      echo "Running $f"
      sudo $f
    done
  fi

## RUNLEVEL 9 ##

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