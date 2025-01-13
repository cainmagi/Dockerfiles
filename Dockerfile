ARG BASE_IMAGE=python:3.12-slim
FROM $BASE_IMAGE

LABEL maintainer="Yuchen Jin <Yuchen.Jin@aramcoamericas.com>" \
      author="Yuchen Jin <cainmagi@gmail.com>" \
      description="CUDA Toolkits and dev files on bare images." \
      version="1.0.0"

# Set configs
ARG INSTALL_MODE=default
ARG INSTALL_OS=debian
ARG NAME_CUDA_TOOLKIT=cuda-toolkit
# The following args are temporary but necessary during the deployment.
# Do not change them.
ARG DEBIAN_FRONTEND=noninteractive

# Force the user to be root
USER root

WORKDIR /home/scripts

# Install dependencies
COPY ./scripts/install-*.sh /home/scripts
COPY ./scripts/install.sh /home/scripts
RUN bash ./install.sh mode=$INSTALL_MODE os=$INSTALL_OS cuda=$NAME_CUDA_TOOLKIT

# Entrypoints
# COPY ./scripts/entrypoint.sh /home/scripts
# ENTRYPOINT ["/bin/bash", "--login", "-i", "/app/entrypoint.sh"]
# CMD [""]
