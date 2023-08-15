# This image is used to run PHP IDEs (e.g. PhpStorm) in a containerized environment.
# Included: PHP, Composer, Helm, Docker CLI, SSH server, xdebug, phpunit

FROM mcr.microsoft.com/devcontainers/base:debian-12
EXPOSE 22

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
RUN chown 1000 /usr/local/bin/docker-entrypoint.sh && chmod +x /usr/local/bin/docker-entrypoint.sh; \
    cat /usr/local/lib/apply_bash_completion >> /etc/bash.bashrc

# Setup .ssh
RUN usermod -aG sudo,vscode vscode && \
    mkdir -p /home/vscode/.ssh && \
    chown -R vscode:vscode /home/vscode/.ssh && \
    chmod 700 /home/vscode/.ssh && \
    echo "vscode ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

VOLUME /home/vscode

WORKDIR /home/vscode
USER 1000
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["sudo", "/usr/sbin/sshd","-D", "-e"]