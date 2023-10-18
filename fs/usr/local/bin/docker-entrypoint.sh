#!/usr/bin/env bash

  # Run user's setup.sh
  if [[ -f $PWD/setup.sh ]]; then
    chmod +x "$PWD/setup.sh"
    "$PWD/start.sh"
  fi

  # Run additional entrypoint scripts.
  if [[ -d /usr/local/bin/entrypoint.d ]]; then
    chmod +x /usr/local/bin/entrypoint.d/*.sh
    for f in /usr/local/bin/entrypoint.d/*.sh; do
      echo "Running $f"
      sudo "$f"
    done
  fi

  # Run any custom startup scripts in userspace
  if [[ -f "$PWD/start.sh" ]]; then
    chmod +x "$PWD/start.sh"
    "$PWD/start.sh"
  fi

# Run the command passed to the container
exec "$@"