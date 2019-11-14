# Dockerfile Collection for DGX-230

## XUbuntu-tensorflow-2

This is the 2.0 version for building a tensorflow image. Since the baseline image is `nvcr.io/nvidia/tensorflow:19.10-py3`, the ubuntu version is 18.04 and the tensorflow version is 1.14+.

### Online building

If you do not want to change the contents of the dockerfile, you could use such command to build the image:

```Bash
$ nvidia-docker build -t xubuntu-tf:2.0 https://github.com/cainmagi/Dockerfiles.git#xubuntu-tf2
```

### Offline building

Otherwise, you need to clone the branch firsly:

```Bash
$ git clone --single-branch -b xubuntu-tf2 https://github.com/cainmagi/Dockerfiles.git xubuntu-tf2
```

After that, run such command to build the image:

```Bash
$ nvidia-docker build -t xubuntu-tf:2.0 xubuntu-tf2
```

where `xubuntu-tf2` is the folder of the corresponding branch.

## Use this image

The noVNC is incorporated inside the docker image, hence use such command to launch the image:

```Bash
$ nvidia-docker run -it --rm -v ~:/homelocal -p 6080:6080 xubuntu-tf:2.0
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

This version of **xubuntu** is particularly designed for installing **gcc-9** inside the docker image *nvcr.io/nvidia/tensorflow*. It has these special features:

* **Two versions of gcc**: it contains gcc-9.2, gcc-6.5, gcc-7.2 and gcc-5.5, where gcc-7.2 is the original version of *nvcr.io/nvidia/tensorflow* but we suggest to use gcc-5.5 in most cases.
* **Fully installed xfce4 desktop**: it has most of the useful plug-ins for xfce4 desktop. While libreoffice and texlive are **not** installed.
* **Support Chinese**: it contains Chinese fonts and input methods.
* **Modern VNC server**: it contains [tigervncserver][tigervnc], which is a modern VNC server and could provide more features than tightvncserver and vnc4server, like cutomizing display settings, fully implemented animated cursor and shadow effects.
* **Well defined start-up script**: it has pre-define `.bashrc` and `xstartup`. All important paths are included like `PKG_CONFIG_PATH` and `LD_LIBRARY_PATH`, which maintains that the **cmake** could find all installed packages.
* **Pre-installed themes**: it has included external themes, icons and backgrounds. You could use **Appearance**, **Desktop** and **Window Manager** in **Settings** to select your cutomized theme.

## Update records

### ver 2.0 @ 20180821

Create this project for incorporating the tensorflow 1.14.

[tigervnc]:https://github.com/TigerVNC/tigervnc "TigerVNC"