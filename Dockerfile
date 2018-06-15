#
# XUbuntu Desktop self-loaded Dockerfile
#
# nvcr.io/nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04
#

# Pull base image.
FROM nvcr.io/nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04

ARG DEBIAN_FRONTEND=noninteractive
ENV USER root

# Install prepared packages.
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-mark hold iptables && \
    apt-get -y dist-upgrade && apt-get autoremove -y && apt-get clean

# Upgrade GCC to 6.x
RUN apt-get install -y --no-install-recommends build-essential software-properties-common python-software-properties python3-software-properties 
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test
RUN apt-get update 
RUN apt-get install -y --no-install-recommends gcc-snapshot
RUN apt-get update 
RUN apt-get install -y --no-install-recommends gcc-6 g++-6
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 60 --slave /usr/bin/g++ g++ /usr/bin/g++-6
RUN apt-get install -y --no-install-recommends gcc-5 g++-5
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 50 --slave /usr/bin/g++ g++ /usr/bin/g++-5

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
RUN apt-get install -f
RUN apt-get upgrade

# Install the desktop
RUN apt-get install build-essential 
RUN apt-get install -y --no-install-recommends firefox
RUN apt-get install -y --no-install-recommends xubuntu-desktop
RUN apt-get install -y vnc4server

# additional packages
RUN apt-get install -y --no-install-recommends ffmpeg libopencv-gpu2.4v5 qt5-default qt5-doc-html qt5-image-formats-plugins qt5-style-plugins
RUN apt-get install -y --no-install-recommends chromium-browser vim-gnome codeblocks vlc smplayer gimp gedit xpdf

RUN add-apt-repository -y ppa:notepadqq-team/notepadqq
RUN apt-get update
RUN apt-get install -y notepadqq

RUN apt-get install -y fonts-wqy-zenhei
RUN [ -d /usr/share/fonts/opentype ] || mkdir /usr/share/fonts/opentype
RUN git clone https://github.com/adobe-fonts/source-code-pro.git /usr/share/fonts/opentype/scp
RUN fc-cache -f -v
RUN apt-get install -y fcitx fcitx-googlepinyin fcitx-table-wbpy fcitx-pinyin fcitx-sunpinyin
RUN apt-get install -y at-spi2-core
RUN /etc/init.d/dbus start

RUN apt-get install -f
RUN apt-get upgrade

COPY docker-entrypoint /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint

# Define working directory.
WORKDIR /workspace

# Define default command.
ENTRYPOINT ["docker-entrypoint"]
