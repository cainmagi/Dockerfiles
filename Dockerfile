#
# XUbuntu Desktop self-loaded Dockerfile
#
# BASE_IMAGE
#

# Pull base image.
ARG BASE_IMAGE=nvcr.io/nvidia/pytorch:20.12-py3
FROM $BASE_IMAGE
LABEL maintainer="Yuchen Jin <cainmagi@gmail.com>" \
      author="Yuchen Jin <cainmagi@gmail.com>" \
      description="xUbuntu desktop dockerfile for ubuntu 16.04, 18.04 and 20.04 images." \
      version="1.5"
ARG BASE_LAUNCH=/usr/local/bin/nvidia_entrypoint.sh
ARG JLAB_VER=unset
ARG JLAB_EXTIERS=2
ARG WITH_CHINESE="true"
ARG WITH_EXTRA_APPS="go"
ARG DEBIAN_FRONTEND=noninteractive

ENV USER="root" MKL_CBWR="AUTO" LAUNCH_SCRIPT_ORIGINAL="$BASE_LAUNCH" PATH="${PATH}:/usr/games"

# Move configs.
COPY configs /root/docker-configs
RUN chmod +x /root/docker-configs/ --recursive && bash /root/docker-configs/detach MODE=basic
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
RUN bash /root/scripts/install-desktop MODE=apps JLAB_VER=${JLAB_VER} JLAB_EXTIERS=${JLAB_EXTIERS}
COPY scripts/install-exapps /root/scripts/
RUN chmod +x /root/scripts/install-exapps && bash /root/scripts/install-exapps EXAPPS=${WITH_EXTRA_APPS} REQAPPS=pae
RUN bash /root/scripts/install-exapps EXAPPS=${WITH_EXTRA_APPS} REQAPPS=gnoa
RUN bash /root/scripts/install-exapps EXAPPS=${WITH_EXTRA_APPS} REQAPPS=x
RUN bash /root/docker-configs/detach MODE=shortcuts

# Install modern vncserver and themes
COPY scripts/install-vnc /root/scripts/
RUN bash /root/scripts/install-vnc MODE=vnc
RUN bash /root/scripts/install-vnc MODE=theme

# Define working directory.
RUN bash /root/docker-configs/detach MODE=clean
COPY docker-entrypoint /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint

# Expose the built-in ports.
EXPOSE 5901
EXPOSE 6080

# Define default command.
USER xubuntu
WORKDIR /home/xubuntu
ENTRYPOINT ["bash", "docker-entrypoint"]
CMD [""]
