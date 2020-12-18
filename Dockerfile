#
# Jupyter Lab self-loaded Dockerfile
#
# BASE_IMAGE
#

# Pull base image.
ARG BASE_IMAGE=nvcr.io/nvidia/tensorflow:19.04-py3
ARG BASE_LAUNCH=/usr/local/bin/nvidia_entrypoint.sh
FROM $BASE_IMAGE
ARG DEBIAN_FRONTEND=noninteractive

ENV USER root
ENV MKL_CBWR AUTO

# Move configs.
COPY configs /root/configs
RUN chmod +x /root/configs/ --recursive && bash /root/configs/detach
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Install prepared packages
COPY scripts/install-base /root/scripts/
RUN chmod +x /root/scripts/install-base && bash /root/scripts/install-base MODE=init

# Install python
COPY scripts/install-python /root/scripts/
RUN chmod +x /root/scripts/install-python && bash /root/scripts/install-python MODE=python
RUN bash /root/scripts/install-python MODE=jupyter
RUN bash /root/scripts/install-base MODE=check

# Define working directory.
ENV LAUNCH_SCRIPT_ORIGINAL=$BASE_LAUNCH
COPY docker-entrypoint /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint
WORKDIR /root

# Define default command.
ENTRYPOINT ["bash", "docker-entrypoint"]
CMD [""]
