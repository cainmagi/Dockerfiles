#
# XUbuntu Desktop self-loaded Dockerfile
#
# BASE_IMAGE
#

# Pull base image.
ARG BASE_IMAGE=nvcr.io/nvidia/tensorflow:19.04-py3
FROM $BASE_IMAGE
LABEL maintainer="Yuchen Jin <cainmagi@gmail.com>" \
      author="Yuchen Jin <cainmagi@gmail.com>" \
      description="xUbuntu desktop dockerfile for ubuntu 16.04, 18.04 and 20.04 images." \
      version="1.5a"
ARG BASE_LAUNCH=/usr/local/bin/nvidia_entrypoint.sh
ARG JLAB_VER=unset
ARG JLAB_EXTIERS=2
ARG XUBUNTU_COMPAT="false"
ARG WITH_CHINESE="true"
ARG WITH_EXTRA_APPS=""
ARG DEBIAN_FRONTEND=noninteractive

ENV USER root
ENV MKL_CBWR AUTO

# Move configs.
COPY configs /root/configs
RUN chmod +x /root/configs/ --recursive && bash /root/configs/detach MODE=basic
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Install prepared packages
COPY scripts/install-base /root/scripts/
RUN chmod +x /root/scripts/install-base && bash /root/scripts/install-base MODE=init

# Install xfce4 Desktop
COPY scripts/install-desktop /root/scripts/
RUN chmod +x /root/scripts/install-desktop && bash /root/scripts/install-desktop MODE=desktop
RUN /etc/init.d/dbus start
RUN bash /root/scripts/install-base MODE=check

# Install extra packages
RUN bash /root/scripts/install-desktop MODE=apps JLAB_VER=${JLAB_VER} JLAB_EXTIERS=${JLAB_EXTIERS} JLAB_COMPAT=${XUBUNTU_COMPAT}
RUN bash /root/configs/detach MODE=shortcuts

# Install modern vncserver and themes
COPY scripts/install-vnc /root/scripts/
RUN bash /root/scripts/install-vnc MODE=vnc NOVNC_COMPAT=${XUBUNTU_COMPAT}
RUN bash /root/scripts/install-vnc MODE=theme

# Define working directory.
ENV LAUNCH_SCRIPT_ORIGINAL=$BASE_LAUNCH
COPY docker-entrypoint /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint
WORKDIR /root

# Expose the built-in ports.
EXPOSE 5901
EXPOSE 6080

# Define default command.
ENTRYPOINT ["bash", "docker-entrypoint"]
CMD [""]
