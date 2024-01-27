#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]
  then IAMROOT=false
else
  IAMROOT=true
fi

  # Run user's setup.sh
  if [[ -f $PWD/setup.sh ]]; then
    if [[ ! $IAMROOT ]]; then
      sudo chmod +x "$PWD/setup.sh"
    else
      chmod +x "$PWD/setup.sh"
    fi
    "$PWD/start.sh"
  fi

  # Run additional entrypoint scripts.
  if [[ -d /usr/local/bin/entrypoint.d ]]; then
    if [[ ! $IAMROOT ]]; then
      sudo chmod +x /usr/local/bin/entrypoint.d/*.sh
    else
      chmod +x /usr/local/bin/entrypoint.d/*.sh
    fi

    for f in /usr/local/bin/entrypoint.d/*.sh; do
      echo "Running $f"
      if [[ ! $IAMROOT ]]; then
        sudo "$f"
      else
        exec "$f"
      fi
    done
  fi

  # Run any custom startup scripts in userspace
  if [[ -f "$PWD/start.sh" ]]; then
    if [[ ! $IAMROOT ]]; then
      sudo chmod +x "$PWD/start.sh"
    else
      chmod +x "$PWD/start.sh"
    fi

    "$PWD/start.sh"
  fi

# Run the command passed to the container
exec "$@"