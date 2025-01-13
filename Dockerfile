ARG BASE_IMAGE=cainmagi/cuda:debian12-cu124
FROM $BASE_IMAGE

LABEL maintainer="Yuchen Jin <Yuchen.Jin@aramcoamericas.com>" \
      author="Yuchen Jin <cainmagi@gmail.com>" \
      description="Deformable-DETR built with CUDA and PyTorch." \
      version="1.0.0"

# The following args are temporary but necessary during the deployment.
# Do not change them.
ARG DEBIAN_FRONTEND=noninteractive

# Force the user to be root
USER root

WORKDIR /home/scripts/deformable-detr

# Install dependencies
COPY ./scripts/*.* /home/scripts/deformable-detr
RUN bash ./install.sh

WORKDIR /opt

# Entrypoints
# COPY ./scripts/entrypoint.sh /home/scripts
# ENTRYPOINT ["/bin/bash", "--login", "-i", "/app/entrypoint.sh"]
# CMD [""]
