#
# XUbuntu Desktop self-loaded Dockerfile
#
# ubuntu:16.04
#

# Pull base image.
FROM ubuntu:16.04

ARG DEBIAN_FRONTEND=noninteractive
ARG BUILD_SIMPLESC=1
ARG PATH="/root/simplescalar/build/bin:/root/simplescalar/build:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ENV USER root
ENV MKL_CBWR AUTO

# Install prepared packages.
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-mark hold iptables && \
    apt-get -y dist-upgrade && apt-get autoremove -y && apt-get clean

# Setting language
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN echo "LANG=en_US.UTF-8" > /etc/locale.conf
COPY locale.gen /etc
RUN apt-get install -y locales
RUN locale-gen en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN update-locale --reset LANG=$LANG
RUN apt-get install -f -y && \
    apt-get upgrade -y && \
    apt-get -y dist-upgrade

# Install the desktop
RUN apt-get install -y --no-install-recommends build-essential 
RUN apt-get install -y --no-install-recommends xubuntu-desktop

# Install the xfce4 addons
RUN apt-get install -y --no-install-recommends xfce4 && \
    apt-get install -y --no-install-recommends gtk3-engines-xfce xfce4-notifyd \
      mousepad xfce4-taskmanager xfce4-terminal lightdm-gtk-greeter-settings && \
    apt-get install -y --no-install-recommends \
      libgtk-3-bin libgtk2.0-bin libgtk-3-dev libgtk2.0-dev && \
    apt-get install -y --no-install-recommends xfce4-battery-plugin xfce4-settings \
      xfce4-clipman-plugin xfce4-cpugraph-plugin xfce4-datetime-plugin \
      xfce4-netload-plugin xfce4-notes-plugin xfce4-places-plugin \
      xfce4-sensors-plugin xfce4-systemload-plugin xfce4-linelight-plugin\
      xfce4-whiskermenu-plugin xfce4-indicator-plugin xfce4-mailwatch-plugin \
      xfce4-cpufreq-plugin xfce4-diskperf-plugin xfce4-fsguard-plugin \
      xfce4-genmon-plugin xfce4-smartbookmark-plugin xfce4-timer-plugin \
      xfce4-verve-plugin xfce4-weather-plugin xfce4-appfinder xfce4-artwork xfce4-dict

# additional packages
RUN apt-get install -y --no-install-recommends chromium-browser gedit okular gnome-screenshot gvfs
RUN apt-get install -y --no-install-recommends apt-transport-https at-spi2-core wget
RUN /etc/init.d/dbus start

RUN apt-get install -f -y && \
    apt-get upgrade -y && \
    apt-get -y dist-upgrade

COPY docker-entrypoint /usr/local/bin/
COPY shortcuts/* /root/Desktop/
COPY get-pip.py /root/
COPY simplescalar /root/simplescalar
RUN apt-get install -y python-pip python3-pip
RUN python3 /root/get-pip.py --force-reinstall && python2 /root/get-pip.py --force-reinstall
RUN chmod +x /root/Desktop/ --recursive && chmod +x /usr/local/bin/docker-entrypoint && chmod +x /root/simplescalar/install-* && chmod 777 /root/simplescalar/f2c-addition/ --recursive

# Install modern vncserver
RUN apt-get -y install x11-utils libfontenc1 libjpeg-turbo8 libpixman-1-0 libtasn1-3-bin libxfont1 libxtst6 x11-xkb-utils libxfont1-dev x11proto-fonts-dev libfontenc-dev && \
    apt-get -f -y install && \
    apt-get -y autoremove
RUN wget -O tigervncserver_1.9.80-1ubuntu1_amd64.deb http://tigervnc.bphinz.com/nightly/ubuntu-16.04LTS/amd64/tigervncserver_1.9.80+20181130git4f19e757-1ubuntu1_amd64.deb
RUN dpkg -i tigervncserver_1.9.80-1ubuntu1_amd64.deb && \
    rm -f tigervncserver_1.9.80-1ubuntu1_amd64.deb
    
# Optional build
RUN if [ "x$BUILD_SIMPLESC" = "x1" ] ; then mkdir -p /root/simplescalar/build && cd /root/simplescalar/build && wget -nc https://github.com/cainmagi/Dockerfiles/releases/download/xubuntu-simplesc-v1.0/simplesim-3v0e.tgz ; fi
RUN if [ "x$BUILD_SIMPLESC" = "x1" ] ; then bash /root/simplescalar/install-simplesc ; fi
RUN if [ "x$BUILD_SIMPLESC" = "x1" ] ; then bash /root/simplescalar/install-f2c ; fi

# Create shortcuts and launch script
COPY xstartup /root/.vnc/
RUN chmod +x /root/.vnc/xstartup

# Define working directory.
WORKDIR /workspace

# Define default command.
ENTRYPOINT ["docker-entrypoint"]
