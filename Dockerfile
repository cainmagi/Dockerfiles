ARG BASE_IMAGE=texlive/texlive:latest-full-doc-src
FROM $BASE_IMAGE

LABEL maintainer="Yuchen Jin <Yuchen.Jin@aramcoamericas.com>" \
      author="Yuchen Jin <cainmagi@gmail.com>" \
      description="VSCode Server with TeXLive." \
      version="1.0.0"

# Set configs
ARG INSTALL_MODE=default
ARG INSTALL_OS=debian
ARG LANG=en_US.UTF-8
ARG EXT_SOURCE=default
# The following args are temporary but necessary during the deployment.
# Do not change them.
ARG DEBIAN_FRONTEND=noninteractive

ENV LANG=${LANG}

# Force the user to be root
USER root

# Install dependencies
WORKDIR /opt/scripts
COPY ./scripts /opt/scripts
RUN bash ./create-user.sh user=codeuser
RUN bash ./install.sh mode=$INSTALL_MODE os=$INSTALL_OS

WORKDIR /opt/post-scripts
COPY ./post-scripts /opt/post-scripts

EXPOSE 8000

# Reconfigure users, and use post-install
USER codeuser
ENV USER="codeuser"
RUN sudo chown $(id -u) /opt/post-scripts --recursive && sudo chgrp $(id -g) /opt/post-scripts --recursive && sudo chmod +rwx /opt/post-scripts --recursive
RUN bash ./post-install.sh mode=$INSTALL_MODE os=$INSTALL_OS code-src=${EXT_SOURCE}

# Copy entrypoints, and run some initializations.
WORKDIR /opt/entrypoints
COPY ./entrypoints /opt/entrypoints
RUN bash ./init-code-config.sh

# Entrypoints
WORKDIR /home/codeuser
ENTRYPOINT ["/bin/bash", "--login", "-i", "/opt/entrypoints/docker-entrypoint.sh"]
CMD [""]
