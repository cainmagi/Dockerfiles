#
# XUbuntu Desktop self-loaded Dockerfile
#
# nvcr.io/nvidia/tensorflow:18.07-py3
#

# Pull base image.
FROM nvcr.io/nvidia/tensorflow:18.07-py3

ARG DEBIAN_FRONTEND=noninteractive
ARG BUILD_OPENCV3=0
ARG BUILD_FFMPEG=0
ARG BUILD_TENSORFLOW=1
ENV USER root

# Install prepared packages.
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-mark hold iptables && \
    apt-get -y dist-upgrade && apt-get autoremove -y && apt-get clean

# Upgrade GCC to 8.x
RUN apt-get install -y --no-install-recommends build-essential software-properties-common python-software-properties python3-software-properties 
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test
RUN apt-get update -y && apt-get install -y --no-install-recommends gcc-snapshot
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 50 --slave /usr/bin/g++ g++ /usr/bin/g++-5
RUN apt-get update -y && apt-get install -y --no-install-recommends gcc-8 g++-8
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 80 --slave /usr/bin/g++ g++ /usr/bin/g++-8
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test -r && apt-get update -y

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
RUN apt-get install build-essential 
RUN apt-get install -y --no-install-recommends firefox
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
RUN apt-get install -y --no-install-recommends ffmpeg libopencv-gpu2.4v5 qt5-default qt5-doc-html qt5-image-formats-plugins qt5-style-plugins
RUN apt-get install -y --no-install-recommends chromium-browser vim-gnome codeblocks vlc smplayer gimp gedit okular gnome-screenshot gvfs
RUN add-apt-repository ppa:nomacs/stable && \
    apt-get update && apt-get install nomacs

RUN add-apt-repository -y ppa:notepadqq-team/notepadqq
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
RUN mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
RUN sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
RUN dpkg --add-architecture i386
RUN apt-get install -y --no-install-recommends apt-transport-https
RUN apt-get update -y
RUN apt-get -y dist-upgrade
RUN apt-get install -y --no-install-recommends notepadqq code
RUN wget https://ufpr.dl.sourceforge.net/project/peazip/6.6.0/peazip_6.6.0.LINUX.GTK2-2_i386.deb -O peazip.deb
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test && apt-get update -y
RUN apt-get install -y --no-install-recommends libatk1.0-0:i386 libc6:i386 libcairo2:i386 libgdk-pixbuf2.0-0:i386 libglib2.0-0:i386 libgtk2.0-0:i386 libpango1.0-0:i386 libx11-6:i386 libcanberra-gtk-module:i386
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test -r && apt-get update -y
RUN dpkg -i peazip.deb && \
    rm -f peazip.deb

RUN apt-get install -y fonts-wqy-zenhei
RUN [ -d /usr/share/fonts/opentype ] || mkdir /usr/share/fonts/opentype
RUN git clone https://github.com/adobe-fonts/source-code-pro.git /usr/share/fonts/opentype/scp
RUN fc-cache -f -v
RUN apt-get install -y fcitx fcitx-googlepinyin fcitx-table-wbpy fcitx-pinyin fcitx-sunpinyin
RUN apt-get install -y at-spi2-core
RUN /etc/init.d/dbus start

RUN apt-get install -f -y && \
    apt-get upgrade -y && \
    apt-get -y dist-upgrade

COPY docker-entrypoint /usr/local/bin/
COPY get-pip.py /root/
RUN python3 /root/get-pip.py --force-reinstall
RUN apt-get remove -y python-pip && \
    apt-get install -y python-pip --reinstall
RUN pip3 install matplotlib Cython numpy scipy scikit-image ipython h5py leveldb networkx nose pandas python-dateutil protobuf python-gflags pyyaml Pillow six Jinja2 Flask
RUN apt-get install -y python3-sip python3-pyqt5 python3-tk
RUN pip3 install numpy --upgrade
RUN chmod +x /usr/local/bin/docker-entrypoint

# Install modern vncserver
RUN apt-get -y install x11-utils libfontenc1 libjpeg-turbo8 libpixman-1-0 libtasn1-3-bin libxfont1 libxtst6 x11-xkb-utils && \
    apt-get -f -y install && \
    apt-get -y autoremove
RUN wget -O tigervncserver_1.9.0-1ubuntu1_amd64.deb https://bintray.com/tigervnc/stable/download_file?file_path=ubuntu-16.04LTS%2Famd64%2Ftigervncserver_1.9.0-1ubuntu1_amd64.deb
RUN dpkg -i tigervncserver_1.9.0-1ubuntu1_amd64.deb && \
    rm -f tigervncserver_1.9.0-1ubuntu1_amd64.deb

# Create shortcuts and launch script
COPY .bashrc /root/
COPY shortcuts/* /root/Desktop/
COPY xstartup /root/.vnc/
COPY install-* /root/
RUN chmod +x /root/Desktop/ --recursive

# Copy backgrounds, icons and themes
RUN wget -qO- https://github.com/cainmagi/Dockerfiles/releases/download/xubuntu-tf-v1.1/share.tar.gz | tar xvz -C /usr/share
RUN gtk-update-icon-cache /usr/share/icons/Adwaita-Xfce && \
    gtk-update-icon-cache /usr/share/icons/Adwaita-Xfce-Mono && \
    gtk-update-icon-cache /usr/share/icons/Adwaita-Xfce-Panel && \
    gtk-update-icon-cache /usr/share/icons/elementary-xfce-darkest && \
    gtk-update-icon-cache /usr/share/icons/Arc-X-D && \
    gtk-update-icon-cache /usr/share/icons/Arc-X-P && \
    gtk-update-icon-cache /usr/share/icons/DarK && \
    gtk-update-icon-cache /usr/share/icons/Numix && \
    gtk-update-icon-cache /usr/share/icons/Numix-Light && \
    gtk-update-icon-cache /usr/share/icons/Paper && \
    gtk-update-icon-cache /usr/share/icons/Paper-Mono-Dark && \
    gtk-update-icon-cache /usr/share/icons/Suru

# Optional build
RUN if [ "x$BUILD_FFMPEG" = "x1" ] || [ "x$BUILD_OPENCV3" = "x1" ] ; then cd /root/ && bash install-ffmpeg ; fi
RUN if [ "x$BUILD_OPENCV3" = "x1" ] ; then cd /root/ && bash install-opencv3 ; fi

# Rebuild tensorflow
RUN if [ "xBUILD_TENSORFLOW" = "x1" ] ; then cd /root/ && bash install-tensorflow-reinstall ; fi

# Define working directory.
WORKDIR /workspace

# Define default command.
ENTRYPOINT ["docker-entrypoint"]
