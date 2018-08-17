# Dockerfile Collection for DGX-230

## XUbuntu-tensorflow

### Online building

If you do not want to change the contents of the dockerfile, you could use such command to build the image:

```Bash
$ nvidia-docker build -t xubuntu-tf:1.0 https://github.com/cainmagi/Dockerfiles.git#xubuntu-tf
```

### Offline building

Otherwise, you need to clone the branch firsly:

```Bash
$ git clone --single-branch -b xubuntu-tf https://github.com/cainmagi/Dockerfiles.git xubuntu-tf
```

After that, run such command to build the image:

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

We have two methods for installing ffmpeg and opencv3. You may select a method according to your case.

### Install ffmpeg and opencv3 by building image

Note tha only if you do not change anything of this dockerfile, you could use this method to build an image with ffmpeg and opencv3 directly. The command is

```Bash
$ nvidia-docker build -t xubuntu-tf:1.0 --build-arg BUILD_OPENCV3=1 https://github.com/cainmagi/Dockerfiles.git#xubuntu-tf
```

If you only want to install ffmpeg, use `BUILD_FFMPEG=1` for instead. Such an option could be also used for offline building.

### Install ffmpeg and opencv3 by running script

If you use the command suggested as it is, you could run the following scripts inside the container after the image is built.

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

### After installation

If you have installed ffmpeg or opencv3, you need to run this command after installtion.

```Bash
$ cd ~
$ bash install-tensorflow-reinstall
```

### Some possible bugs

* The `make test` for opencv3 may not be processed well during the testing for cuda.
* You should not add `ppa:ubuntu-toolchain-r/test` by yourself, because we need to keep the gcc-5.4 back and not upgraded to gcc-5.5. But we may meet errors when using `apt-get`. If we find "*dependency error*" related to gcc, we could try to install the apps like this:
    ```Bash
    $ add-apt-repository -y ppa:ubuntu-toolchain-r/test && apt-get update -y 
    $ apt-get install ...
    $ add-apt-repository -y ppa:ubuntu-toolchain-r/test -r && apt-get update -y 
    ```
   
## Update records

### ver 1.14 @ 20180817

We have found that tensorflow 1.8.0 is not compatible with numpy 1.15.0, so we have to switch the latter one back to 1.14.5.

### ver 1.13 @ 20180817
Fix the bug that the xstartup does not be authorized by online building.

### ver 1.12 @ 20180816

1. Update the base tensorflow image to 18.07.
2. Update tigervnc to 1.9.0.
3. Enable users to determine whether to rebuild tensorflow during the building phase.

### ver 1.1 @ 20180816

1. Provide options for the dockerfile to let it be able to build ffmpeg and opencv3 automatically.
2. Fix the bug that the tensorboard could not be use by rebuilding tensorflow after building the image.

### ver 1.0 @ 20180815

Create the dockerfile branch.

[tigervnc]:https://github.com/TigerVNC/tigervnc "TigerVNC"