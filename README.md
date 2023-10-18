# Remote IDE base container

## General information
This is my personal remote IDE base container. It spins up basic Debian container with some additional packages installed. Most importantly it works as base image for more specific IDE images.

Basic features include an SSH server for connecting (you need to figure out connectivity depending on deployment strategy)

## How to use?

### Basics
You can use this container either locally as you please or remotely through SSH. The login password is either provided by you or set randomly at container startup. If you don't provide a password, it is randomly set *each time you start the container*. The random password is printed by the container.
`.ssh/authorized_keys` is rebuilt on every container start. See below for persisting keys.

### Helm chart?!
Not yet.

### Environment variables
- `$IDE_PASSWORD` sets the login password for the created user. User name, however is set during image build and shouldn't be changed any more; the default is `vscode`.
- You can provide a single ssh key through the environment variable `SSH-KEY`, if it happens to contain no illegal characters.

### Special mount locations
- `/home/vscode/.ssh/authorized_keys.d`: Every file under this directory ending in .key will be included in .ssh/authorized_keys.
- `/home/vscode`: The home directory is persisted.
- `/usr/local/etc/ssh`: The location of ssh(d) configuration. This is persisted to maintain ssh keys over instances.

### Custom scripting
You can add scripts to be run at container startup. `/home/vscode/setup.sh` is executed in the beginning of the entrypoint script, scripts in `/usr/local/bin/entrypoint.d/` are executed next and `/home/vscode/start.sh` at the end. Commands are not, by default, run as root, but you can use sudo to run commands with higher privileges. Please note that `/usr/local/bin/entrypoint.d` might also include scripts included with the image, so do not mount it from an external source unless you know what you are doing.

### Extending container
Easiest way is to build an image using this as the source image. Instead of changing the docker-entrypoint.sh script itself you can extend entrypoint setup by placing additional scripts under `/usr/local/bin/entrypoint.d/`). All files with ending `.sh` will be executed during entrypoint. Note that entrypoint is run as the user, so use sudo where necessary.