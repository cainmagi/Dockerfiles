# Dockerfile Collection for DGX-230

## XUbuntu-simplesc

### Online building

If you do not want to change the contents of the dockerfile, you could use such command to build the image:

```Bash
$ nvidia-docker build -t xubuntu-simplesc:1.0 https://github.com/cainmagi/Dockerfiles.git#xubuntu-simplesc
```

### Offline building

Otherwise, you need to clone the branch firsly:

```Bash
$ git clone --single-branch -b xubuntu-simplesc https://github.com/cainmagi/Dockerfiles.git xubuntu-simplesc
```

After that, run such command to build the image:

```Bash
$ nvidia-docker build -t xubuntu-simplesc:1.0 xubuntu-simplesc
```

where `xubuntu-simplesc` is the folder of the corresponding branch.

## Features

This is the minimal desktop test based on *ubuntu:16.04* image, it has:

* **Fully installed xfce4 desktop**: it has most of the useful plug-ins for xfce4 desktop. While libreoffice and texlive are **not** installed.
* **Modern VNC server**: it contains [tigervncserver][tigervnc], which is a modern VNC server and could provide more features than tightvncserver and vnc4server, like cutomizing display settings, fully implemented animated cursor and shadow effects.
* **Fully implemented SimpleScalar v3.0e**: Thanks to [sdenel's work][sdenel], we could implement the SimpleScalar on Ubuntu 16.04 and GCC 5.4.0. Since sdenel's work use the same license with that of this project, we do not need to introduce another license for his work.
* **SimpleScalar v3.0e**: Note that this public project has a copy-right license which has been attached with this branch, please confirm that you agree with both licences before using this dockerfile.

## Update records

### ver 1.0 @ 20181201

Create the dockerfile branch.

[sdenel]:https://github.com/sdenel/How-to-install-SimpleScalar-on-Ubuntu "How-to install SimpleScalar on Ubuntu"
[tigervnc]:https://github.com/TigerVNC/tigervnc "TigerVNC"