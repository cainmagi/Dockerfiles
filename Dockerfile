#
# XUbuntu Desktop self-loaded Dockerfile
#
# nvcr.io/nvidia/caffe:18.07-py2
#

# Pull base image.
FROM nvcr.io/nvidia/caffe:18.07-py2

ARG DEBIAN_FRONTEND=noninteractive
ARG BUILD_GCC=1
ARG BUILD_CAFFE_INDEP=1
ARG BUILD_CAFFE=0
ENV USER root

# Install prepared packages.
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-mark hold iptables && \
    apt-get -y dist-upgrade && apt-get autoremove -y && apt-get clean

# Upgrade GCC to 8.2 and 6.3
RUN apt-get install -y --no-install-recommends build-essential software-properties-common python-software-properties python3-software-properties 
# Require for special design installation
COPY .bashrc /root/
COPY install-gcc /root/
RUN chmod +x /root/install-gcc && chmod +x /root/.bashrc && bash /root/.bashrc
RUN if [ "x$BUILD_GCC" = "x1" ] ; then bash /root/install-gcc ; fi

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
RUN apt-get install -y --no-install-recommends chromium-browser vim-gnome codeblocks vlc smplayer gimp gedit gnome-screenshot gvfs
RUN add-apt-repository -y ppa:nomacs/stable && \
    apt-get update -y && apt-get install nomacs -y --no-install-recommends

# Install LibreOffice and Texlive    
RUN apt-add-repository -y ppa:libreoffice/ppa && apt-get -y update
RUN apt-get install -y --no-install-recommends libreoffice
RUN add-apt-repository -y ppa:jonathonf/texlive && apt-get -y update
RUN apt-get install -y --no-install-recommends texlive-full kile

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
RUN apt-get install -y --no-install-recommends libatk1.0-0:i386 libc6:i386 libcairo2:i386 libgdk-pixbuf2.0-0:i386 libglib2.0-0:i386 libgtk2.0-0:i386 libpango1.0-0:i386 libx11-6:i386 libcanberra-gtk-module:i386
RUN dpkg -i peazip.deb && rm -f peazip.deb
RUN wget ftp://ftp.adobe.com/pub/adobe/reader/unix/9.x/9.5.5/enu/AdbeRdr9.5.5-1_i386linux_enu.deb -O adobereader.deb
RUN apt-get install -y --no-install-recommends libgtk2.0-0:i386 libnss3-1d:i386 libnspr4-0d:i386 libxml2:i386 libxslt1.1:i386 libstdc++6:i386
RUN dpkg -i adobereader.deb && rm -f adobereader.deb && apt-get -y -f install

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
RUN python2 /root/get-pip.py --force-reinstall
RUN apt-get remove -y python3-pip && \
    apt-get install -y python3-pip --reinstall
RUN pip2 install matplotlib Cython numpy scipy scikit-image ipython h5py leveldb networkx nose pandas python-dateutil protobuf python-gflags pyyaml Pillow six Jinja2 Flask
RUN apt-get install -y python-sip python-pyqt5 python-tk
RUN pip2 install numpy --upgrade
RUN chmod +x /usr/local/bin/docker-entrypoint
    
# Install modern vncserver
RUN apt-get -y install x11-utils libfontenc1 libjpeg-turbo8 libpixman-1-0 libtasn1-3-bin libxfont1 libxtst6 x11-xkb-utils libxfont1-dev x11proto-fonts-dev libfontenc-dev && \
    apt-get -f -y install && \
    apt-get -y autoremove
RUN wget -O tigervncserver_1.9.0-1ubuntu1_amd64.deb https://bintray.com/tigervnc/stable/download_file?file_path=ubuntu-16.04LTS%2Famd64%2Ftigervncserver_1.9.0-1ubuntu1_amd64.deb
RUN dpkg -i tigervncserver_1.9.0-1ubuntu1_amd64.deb && \
    rm -f tigervncserver_1.9.0-1ubuntu1_amd64.deb
    
# Create shortcuts and launch script
COPY shortcuts/* /root/Desktop/
COPY xstartup /root/.vnc/
# COPY install-caffe-* /root/
RUN chmod +x /root/Desktop/ --recursive && chmod +x /root/.vnc/xstartup && chmod +x /root/install-caffe-*

# Copy backgrounds, icons and themes
RUN wget -qO- https://github.com/cainmagi/Dockerfiles/releases/download/xubuntu-tf-v1.15/share.tar.gz | tar xz -C /usr/share
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

# Rebuild caffe
RUN bash /root/.bashrc
RUN if [ "x$BUILD_CAFFE_INDEP" = "x1" ] ; then if [ "x$BUILD_GCC" = "x1" ] ; then bash /root/install-caffe-dependency; else bash /root/install-caffe-dependency-nonmatlab; fi; fi
RUN if [ "x$BUILD_CAFFE" = "x1" ] ; then if [ "x$BUILD_GCC" = "x1" ] ; then bash /root/install-caffe-reinstall; else bash /root/install-caffe-reinstall-nonmatlab; fi; fi

# Define working directory.
WORKDIR /workspace

# Define default command.
ENTRYPOINT ["docker-entrypoint"]
