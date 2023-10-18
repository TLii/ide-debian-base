#!/usr/bin/env bash

  # Setup sshd
  if [[ -d /usr/local/etc/ssh ]] && [[ -n "$( ls -A /usr/local/etc/ssh )" ]]; then
    sudo rm -r /etc/ssh
  else
    sudo mkdir -p /usr/local/etc/ssh
    sudo ssh-keygen -A
    sudo mv /etc/ssh/* /usr/local/etc/ssh/
    sudo rm -r /etc/ssh
  fi

  sudo ln -s /usr/local/etc/ssh /etc/ssh

  [[ -d /run/sshd ]] || sudo mkdir -p /run/sshd