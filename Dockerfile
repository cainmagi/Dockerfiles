#
# Jupyter Lab self-loaded Dockerfile
#
# BASE_IMAGE
#

# Pull base image.
ARG BASE_IMAGE=nvcr.io/nvidia/tensorflow:19.04-py3
FROM $BASE_IMAGE
LABEL maintainer="Yuchen Jin <cainmagi@gmail.com>" \
      author="Yuchen Jin <cainmagi@gmail.com>" \
      description="Jupyter Lab dockerfile supporting 1.x, 2.x and 3.x versions." \
      version="1.3a"
ARG DEBIAN_FRONTEND=noninteractive
ARG BASE_LAUNCH=/usr/local/bin/nvidia_entrypoint.sh
ARG JLAB_VER=unset
ARG JLAB_EXTIERS=2
ARG JLAB_IMODE=conda
ARG ADDR_PROXY=unset

ENV USER=root MKL_CBWR=AUTO LAUNCH_SCRIPT_ORIGINAL=$BASE_LAUNCH

# Move configs.
COPY configs /root/configs
RUN chmod +x /root/configs/ --recursive && bash /root/configs/detach
ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8

# Install prepared packages
COPY scripts/install-base /root/scripts/
RUN chmod +x /root/scripts/install-base && bash /root/scripts/install-base MODE=init

# Install python
COPY scripts/install-python /root/scripts/
RUN chmod +x /root/scripts/install-python && bash /root/scripts/install-python MODE=python
COPY scripts/install-jlab* /root/scripts/
RUN chmod +x /root/scripts/install-jlab /root/scripts/install-jlab-conda && bash /root/scripts/install-python MODE=jupyter JLAB_VER=${JLAB_VER} JLAB_EXTIERS=${JLAB_EXTIERS} JLAB_IMODE=${JLAB_IMODE}
RUN bash /root/scripts/install-base MODE=check

# Define working directory.
COPY docker-entrypoint /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint
WORKDIR /root

# Expose the built-in ports.
EXPOSE 6080

# Define default command.
ENTRYPOINT ["bash", "docker-entrypoint"]
CMD [""]
