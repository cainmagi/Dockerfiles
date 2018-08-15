# Dockerfile Collection for DGX-230

## XUbuntu

Download the branch and run such command to build the image:

```Bash
$ nvidia-docker build -t xubuntu-tf:1.0 xubuntu-tf
```

where `xubuntu-tf` is the folder of the corresponding branch.

## Features

This version of **xubuntu** is particularly designed for installing **ffmpeg** and **opencv3** inside the docker image *nvcr.io/nvidia/tensorflow*. It has these special features:

* **Two versions of gcc**: it contains gcc-8.1 and gcc-5.4, where gcc-5.4 is the original version of *nvcr.io/nvidia/tensorflow*.
* **Fully installed xfce4 desktop**: it has most of the useful plug-ins for xfce4 desktop. While libreoffice and texlive are **not** installed.
* **Support Chinese**: it contains Chinese fonts and input methods.
* **Modern VNC server**: it contains [tigervncserver][tigervnc], which is a modern VNC server and could provide more features than tightvncserver and vnc4server, like cutomizing display settings, fully implemented animated cursor and shadow effects.
* **Well defined start-up script**: it has pre-define `.bashrc` and `xstartup`. All important paths are included like `PKG_CONFIG_PATH` and `LD_LIBRARY_PATH`, which maintains that the **cmake** could find all installed packages.
* **Pre-installed themes**: it has included external themes, icons and backgrounds. You could use **Appearance**, **Desktop** and **Window Manager** in **Settings** to select your cutomized theme.
* **Fully installed ffmpeg**: it is accompanied with a script for installing the full ffmpeg which includes shared libraries, all external dependencies and support for GPU.
* **Almost fully installed opencv3**: it is accompanied with a script for installing opencv3 with all image processing libraries, video processing libraries, parallel libraries, GTK GUI, Java toolkit, Ceres solver and some other features. Note that it is provided for python.

## Instructions

### Install ffmpeg

After building sucessfully, use this command:

```Bash
$ cd ~
$ bash install-ffmpeg
```

If succeed, you should not be able to see any error report. Note that the libraries are download in `/apps/source`, built in `/apps/build` and installed in `/usr/local/bin`. You could change these path in the script easily.

### Install opencv3

It is important that **you need to install ffmpeg before installing this library**.

Use this command to do that:

```Bash
$ cd ~
$ bash install-opencv3
```

If succeed, you should not be able to see any error report. Note that the libraries are download in `/apps/source`, built in `/apps/build` and installed in `/usr/local`. You could change these path in the script easily.

### Some possible bugs

* The `make test` for opencv3 may not be processed well during the testing for cuda.
* You should not add `ppa:ubuntu-toolchain-r/test` by yourself, because we need to keep the gcc-5.4 back and not upgraded to gcc-5.5. But we may meet errors when using `apt-get`. If we find "*dependency error*" related to gcc, we could try to install the apps like this:
    ```Bash
    $ add-apt-repository -y ppa:ubuntu-toolchain-r/test && apt-get update -y 
    $ apt-get install ...
    $ add-apt-repository -y ppa:ubuntu-toolchain-r/test -r && apt-get update -y 
    ```
   
## Update records

### ver 1.0 @ 20180815

Create the dockerfile branch.

[tigervnc]:https://github.com/TigerVNC/tigervnc "TigerVNC"