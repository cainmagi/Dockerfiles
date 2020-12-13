#
# XUbuntu Desktop self-loaded Dockerfile
#
# BASE_IMAGE
#

# Pull base image.
ARG BASE_IMAGE=nvcr.io/nvidia/tensorflow:19.04-py3
ARG BASE_LAUNCH=/usr/local/bin/nvidia_entrypoint.sh
FROM $BASE_IMAGE

ENV USER root
ENV MKL_CBWR AUTO
ENV LAUNCH_SCRIPT_ORIGINAL=$BASE_LAUNCH

# Move configs.
COPY configs /root/configs
RUN chmod +x /root/configs/ --recursive && bash /root/configs/detach
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Install prepared packages
COPY scripts/install-base /root/scripts/
RUN chmod +x /root/install-base && bash /root/install-base MODE=init

# Install xfce4 Desktop
COPY scripts/install-desktop /root/scripts/
RUN chmod +x /root/install-desktop && bash /root/install-desktop MODE=desktop
RUN /etc/init.d/dbus start
RUN bash /root/install-base MODE=check

# Install extra packages
RUN bash /root/install-desktop MODE=apps

# Install modern vncserver
RUN bash /root/install-desktop MODE=vnc

# Install themes
COPY scripts/install-themes /root/scripts/
RUN bash /root/install-desktop MODE=theme

# Create shortcuts and launch script
COPY xstartup /root/.vnc/
COPY docker-entrypoint /usr/local/bin/
RUN chmod +x /root/.vnc/xstartup

# Define working directory.
WORKDIR /root

# Define default command.
ENTRYPOINT ["docker-entrypoint"]
