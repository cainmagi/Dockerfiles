# Dockerfile Collection for DGX-230

## XUbuntu

### Online building

If you do not want to change the contents of the dockerfile, you could use such command to build the image:

```Bash
$ nvidia-docker build -t xubuntu:1.0 https://github.com/cainmagi/Dockerfiles.git#xubuntu
```

### Offline building

Otherwise, you need to clone the branch firsly:

```Bash
$ git clone --single-branch -b xubuntu https://github.com/cainmagi/Dockerfiles.git xubuntu
```

After that, run such command to build the image:

```Bash
$ nvidia-docker build -t xubuntu:1.0 xubuntu
```

where `xubuntu` is the folder of the corresponding branch.

## Features

This is the minimal desktop test based on *ubuntu:16.04* image, it has:

* **Fully installed xfce4 desktop**: it has most of the useful plug-ins for xfce4 desktop. While libreoffice and texlive are **not** installed.
* **Modern VNC server**: it contains [tigervncserver][tigervnc], which is a modern VNC server and could provide more features than tightvncserver and vnc4server, like cutomizing display settings, fully implemented animated cursor and shadow effects.

## Update records

### ver 1.0 @ 20181201

Create the dockerfile branch.

[tigervnc]:https://github.com/TigerVNC/tigervnc "TigerVNC"