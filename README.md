# Remote IDE base container

## General information

This is my personal remote IDE base container. It spins up basic Debian container with some additional packages installed. Most importantly it works as base image for more specific IDE images.

Basic features include an SSH server for connecting (you need to figure out connectivity depending on deployment strategy)

## How to use?

### Basics

You can use this container either locally as you please or remotely through SSH. The login password is either provided by you or set randomly at container startup. If you don't provide a password, it is randomly set *each time you start the container*. The random password is printed to `stdout`.
`.ssh/authorized_keys` is rebuilt on every container start. See below for persisting keys.

### Helm chart?!

Not yet.

### Environment variables

- `$IDE_PASSWORD` sets the login password for the created user. User name, however is set during image build and shouldn't be changed any more; the default is `vscode`.
- `SSH-KEY` can be used to provide SSH keys to be included in `.ssh/authorized_keys`, which is (re)built on container start. You can also place keyfiles under `authorized_keys.d/` (see below)

### Special mount locations

- `/home/vscode`: The home directory is persisted. At least subdirectory `.ssh` should be persisted, even if you want to clone source code every time you start the container (which you probably don't).
- `/usr/local/etc/ssh`: The location of ssh(d) configuration. This should be persisted to maintain ssh keys over instances.

### Persisting SSH
To ensure painless SSH connection, you should persist container sshd's server keys as and other configuration instructed above. By persisting them you'll avoid warnings and/or errors about changing server keys and key fingerprints.
If you want to use SSH key authentication instead of passwords, you can provide container with SSH keys in either of two ways (or even both):
- providing keys as and environment variable in base64 encoded format; and/or
- placing keyfiles under `$HOME/.ssh/authorized_keys.d`
Password login for the user is always available. You can use that if key authentication is not possible. You can either provide a chosen password with `IDE_PASSWORD` or let the container make one for you during startup. The latter choice implies the password will change on every container restart.

### Custom scripting

You can add scripts to be run at container startup. `/home/vscode/setup.sh` is executed in the beginning of the entrypoint script, scripts in `/usr/local/bin/entrypoint.d/` are executed next and `/home/vscode/start.sh` at the end. Commands are not, by default, run as root, but you can use sudo to run commands with higher privileges. Please note that `/usr/local/bin/entrypoint.d` might also include scripts included with the image, so do not mount it from an external source unless you know what you are doing.

### Extending container

Easiest way is to build an image using this as the source image. Instead of changing the docker-entrypoint.sh script itself you can extend entrypoint setup by placing additional scripts under `/usr/local/bin/entrypoint.d/`). All files with ending `.sh` will be executed during entrypoint. Note that entrypoint is run as the user, so use sudo where necessary.
