# Dockerfile Collection for DGX-230

## XUbuntu

**Note that this branch needs to be upgraded, and currently it is not useable.**

### Online building

If you do not want to change the contents of the dockerfile, you could use such command to build the image:

```Bash
$ nvidia-docker build -t xubuntu:1.12 https://github.com/cainmagi/Dockerfiles.git#xubuntu
```

### Offline building

Otherwise, you need to clone the branch firsly:

```Bash
$ git clone --single-branch -b xubuntu https://github.com/cainmagi/Dockerfiles.git xubuntu
```

After that, run such command to build the image:

```Bash
$ nvidia-docker build -t xubuntu:1.12 xubuntu
```

where `xubuntu` is the folder of the corresponding branch.

## Features

This version of **xubuntu** is particularly designed for installing **ffmpeg** and **opencv3** inside the docker image *nvcr.io/nvidia/tensorflow*. It has these special features:

* **Three versions of gcc**: it contains gcc-8.2, gcc-6.3 and gcc-5.4, where gcc-5.4 is the original version of *nvcr.io/nvidia/caffe* and we suggest to use gcc-6.3.
* **Fully installed xfce4 desktop**: it has most of the useful plug-ins for xfce4 desktop. While libreoffice and texlive are **not** installed.
* **Support Chinese**: it contains Chinese fonts and input methods.
* **Modern VNC server**: it contains [tigervncserver][tigervnc], which is a modern VNC server and could provide more features than tightvncserver and vnc4server, like cutomizing display settings, fully implemented animated cursor and shadow effects.
* **Well defined start-up script**: it has pre-define `.bashrc` and `xstartup`. All important paths are included like `PKG_CONFIG_PATH` and `LD_LIBRARY_PATH`, which maintains that the **cmake** could find all installed packages.
* **Pre-installed themes**: it has included external themes, icons and backgrounds. You could use **Appearance**, **Desktop** and **Window Manager** in **Settings** to select your cutomized theme.
* **With useful tools**: it has already contains texlive, libreoffice, adobe reader 9, vscode and several tools.
* **Prepared caffe dependencies**: the gcc is installed by compilation and we have prepared protobuf-3.5.1 and bootstrap-1.66 which are required by building caffe with gcc-6.

Actually, nvidia has provided a method to rebuild the customized caffe. However, in our case, we need to compile it with MATLAB R2018a, which requires gcc-6.3.0 for `mex`. Thus some dependencies like *protobuf* and *bootstrap* may not be able to be installed by apt-get. In our solution, we have already prepared scripts for building and installing those dependencies. Therefore, you could build caffe with gcc-6.3.0 and MATLAB.

## Instructions

### Install without MATLAB

Note that this image is prepared for those who need to use caffe with MATLAB. But in this image, MATLAB has not been installed yet. So if you do not need to use MATLAB, please use this command to build your image.

```Bash
$ nvidia-docker build -t xubuntu:1.12 --build-arg BUILD_GCC=0 --build-arg BUILD_CAFFE=1 https://github.com/cainmagi/Dockerfiles.git#xubuntu
```

We have prepared a launch icon for MATLAB when building the image. Because you do not need it, you could delete it on your desktop after the installation.

### Install with MATLAB

For those who need to install MATLAB after building this image, please follow these instructions:

1. Build the image by the suggested command with default options.
2. Install MATLAB in `/usr/local/`
3. Add `export PATH=$PATH:/usr/local/MATLAB/R2018a/bin/` to your `.bashrc` so that you could call `mex` in terminal.
4. You had better to use `update-alternatives --config gcc` to select `gcc-6` as your default compiler. However you could skip this step because the installation script would choose gcc-6 automatically.
5. Run `install-caffe-reinstall` in your `/root/` folder.

### Some possible bugs

We have found that in MATLAB, `caffe.test.test_solver` would cause a collision, which means there may some errors for loading a solver. Unfortunately we have not found a solution for it.
   
## Update records

### ver 1.2beta @ 20180821

Tag this branch with "beta" sign.

### ver 1.12 @ 20180819

1. A full version has been built.
2. Add install-caffe-* to the scripts.
3. Add more launch icons for the desktop.

### ver 1.1beta @ 20180818

A testing for the preparation for new caffe image.

### ver 1.0 @ 20180605

Create the dockerfile branch.

[tigervnc]:https://github.com/TigerVNC/tigervnc "TigerVNC"