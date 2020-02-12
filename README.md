# Dockerfile Collection for DGX-230

## XUbuntu-torch

This docker build file is designed for building a pyTorch image. Since the baseline image is `nvcr.io/nvidia/pytorch:20.01-py3`, the ubuntu version is 18.04 and the pyTorch version is 1.4.0.

### Online building

If you do not want to change the contents of the dockerfile, you could use such command to build the image:

```Bash
$ nvidia-docker build -t xubuntu-tc:1.0 https://github.com/cainmagi/Dockerfiles.git#xubuntu-torch
```

### Offline building

Otherwise, you need to clone the branch firsly:

```Bash
$ git clone --single-branch -b xubuntu-torch https://github.com/cainmagi/Dockerfiles.git xubuntu-torch
```

After that, run such command to build the image:

```Bash
$ nvidia-docker build -t xubuntu-tc:1.0 xubuntu-torch
```

where `xubuntu-tc` is the folder of the corresponding branch.

## Use this image

The noVNC is incorporated inside the docker image, hence use such command to launch the image:

```Bash
$ nvidia-docker run -it --rm -v ~:/homelocal -p 6080:6080 xubuntu-tc:1.0
```

There is a tip, if the 6080 port has been occupied, change it by another value, for example, using

```bash
$ ... -p 6081:6080 ... 
```

If you find that the noVNC could be accessed, but the server could not be connected, this problem may be caused by saving the image without closing server before. In this case, you need to shut down the current server and delete these files:

```bash
rm ~/.vnc/*.log
rm ~/.vnc/*.pid
rm ~/tmp/.X11-unix
```

Then save the image again.

## Features

This version of **xubuntu** is particularly designed for installing **gcc-9** inside the docker image *nvcr.io/nvidia/pytorch*. It has these special features:

* **Two versions of gcc**: it contains gcc-9.2, gcc-6.5, gcc-7.2 and gcc-5.5, where gcc-7.4 is the original version of *nvcr.io/nvidia/pytorch* but we suggest to use gcc-5.5 in most cases.
* **Fully installed xfce4 desktop**: it has most of the useful plug-ins for xfce4 desktop. While libreoffice and texlive are **not** installed.
* **Support Chinese**: it contains Chinese fonts and input methods.
* **Modern VNC server**: it contains [tigervncserver][tigervnc], which is a modern VNC server and could provide more features than tightvncserver and vnc4server, like cutomizing display settings, fully implemented animated cursor and shadow effects.
* **Well defined start-up script**: it has pre-define `.bashrc` and `xstartup`. All important paths are included like `PKG_CONFIG_PATH` and `LD_LIBRARY_PATH`, which maintains that the **cmake** could find all installed packages.
* **Pre-installed themes**: it has included external themes, icons and backgrounds. You could use **Appearance**, **Desktop** and **Window Manager** in **Settings** to select your cutomized theme.

## Update records

### ver 1.0 @ 20200211

Create this project for incorporating the pyTorch 1.4.0.

[tigervnc]:https://github.com/TigerVNC/tigervnc "TigerVNC"