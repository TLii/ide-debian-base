#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]
  then IAMROOT=false
else
  IAMROOT=true
fi

  # Run user's setup.sh
  if [[ -f $PWD/setup.sh ]]; then
    "$PWD/start.sh"
  fi

  # Run additional entrypoint scripts.
  if [[ -d /usr/local/bin/entrypoint.d ]]; then

    for f in /usr/local/bin/entrypoint.d/*.sh; do
      echo "Running $f"
        "$f"
    done
  fi

  # Run any custom startup scripts in userspace
  if [[ -f "$PWD/start.sh" ]]; then
    "$PWD/start.sh"
  fi

# Run the command passed to the container
exec "$@"