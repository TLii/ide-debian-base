# This image is used to run PHP IDEs (e.g. PhpStorm) in a containerized environment.
# Included: PHP, Composer, Helm, Docker CLI, SSH server, xdebug, phpunit

FROM debian
LABEL description="Base container for remote IDEs. Sets up and exposes a basic SSH server reachable with IDE_USERNAME vscode (unless you change it)"
EXPOSE 22

ENV IDE_USERNAME=vscode
ENV IDE_GID=1001
ENV IDE_UID=1001
ENV IDE_HOMEDIR=/home/vscode

## FUNDAMENTALS ##
# Install base system
RUN apt-get update && apt-get install --no-install-recommends -y \
        openssh-server \
        vim \
        ca-certificates \
        curl \
        apt-transport-https \
        git \
        gnupg \
        unzip \
        lsb-release \
        sudo \
        coreutils \
        bash-completion

COPY fs /

# Setup container environment
RUN chown $IDE_UID /usr/local/bin/docker-entrypoint.sh && chmod +x /usr/local/bin/docker-entrypoint.sh; \
    cat /usr/local/lib/apply_bash_completion >> /etc/bash.bashrc

# Setup .ssh
RUN groupadd -g $IDE_GID $IDE_USERNAME; \
    useradd -d $IDE_HOMEDIR -m -N -g $IDE_USERNAME -u $IDE_UID -G sudo $IDE_USERNAME -s /bin/bash; \
    mkdir -p $IDE_HOMEDIR/.ssh;  \
    chown -R $IDE_USERNAME:$IDE_USERNAME $IDE_HOMEDIR/.ssh;  \
    chmod 700 $IDE_HOMEDIR/.ssh; \
    echo "$IDE_USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers;

VOLUME ["$IDE_USERNAME", "/usr/local/etc/ssh"]

WORKDIR $IDE_USERNAME
USER $IDE_UID:$IDE_GID

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["sudo", "/usr/sbin/sshd","-D", "-e"]