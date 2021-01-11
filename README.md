# Dockerfile Collection for DGX-230

## XUbuntu

### Online building

If you do not want to change the contents of the dockerfile, you could use such command to build the image:

```Bash
docker build -t xubuntu:1.0 https://github.com/cainmagi/Dockerfiles.git#xubuntu
```

This image is compatible for Ubuntu 16.04, 18.04 and 20.04. Please check your base image and confirm that the Ubuntu inside the image is compatible with this dockerfile.

We provide 3 examples:

* Start from `pytorch 1.8.0a` image: `docker build -t xubuntu-tc:1.0 --build-arg BASE_IMAGE=nvcr.io/nvidia/pytorch:20.12-py3 --build-arg BASE_LAUNCH=/usr/local/bin/nvidia_entrypoint.sh https://github.com/cainmagi/Dockerfiles.git#xubuntu`
* Start from `cuda 11.1` image: `docker build -t xubuntu-cuda:1.0 --build-arg BASE_IMAGE=nvcr.io/nvidia/cuda:11.1-cudnn8-runtime-ubuntu20.04 --build-arg BASE_LAUNCH="" https://github.com/cainmagi/Dockerfiles.git#xubuntu`
* Start from `tensorflow 1.13.1` image: `docker build -t xubuntu-tf:1.0 --build-arg BASE_IMAGE=nvcr.io/nvidia/tensorflow:19.03-py3 --build-arg BASE_LAUNCH=/usr/local/bin/nvidia_entrypoint.sh --build-arg NOVNC_COMPAT=true https://github.com/cainmagi/Dockerfiles.git#xubuntu`

There are 3 available options:

| Option | Description | Default |
| :-----: | ----- | ----- |
| `BASE_IMAGE` | The base image for building this desktop image. | `nvcr.io/nvidia/tensorflow:19.04-py3` |
| `BASE_LAUNCH` | The entrypoint script from the base image. If there is no entry script, please use `""`. | `/usr/local/bin/nvidia_entrypoint.sh` |
| `NOVNC_COMPAT` | If set, the noVNC would be switched to compatible mode. It should be used when your `python` is `<=3.5`. | ` ` |

To find your launch script of your base image, use

```bash
docker inspect <your-base-image>:<tag>
```

### Offline building

Otherwise, you need to clone the branch firsly:

```Bash
git clone --single-branch -b xubuntu https://github.com/cainmagi/Dockerfiles.git xubuntu
```

After that, run such command to build the image:

```Bash
docker build -t xubuntu:1.0 xubuntu
```

where `xubuntu` is the folder of the corresponding branch. The options in online building examples could be also used for offline buliding.

### Launching

* By built-in `noVNC`: In default mode, you just need to launch the built image by:

    ```bash
    docker run --gpus all -it --rm -v ~:/homelocal -p 6080:6080 xubuntu:1.0
    ```

* By external VNC viewer: If you have installed a VNC viewer on your client side, and want to connect the VNC server of the image directly, please use:

    ```bash
    docker run --gpus all -it --rm -v ~:/homelocal -p 5901:5901 xubuntu:1.0
    ```

* By `BASH`: If you want to enter the command line but do not start the desktop, please use

    ```bash
    docker run --gpus all -it --rm -v ~:/homelocal xubuntu-tc:1.0 --bash
    ```

* By any script: If you want run any script inside the docker for only one time, please use

    ```bash
    docker run --gpus all -it --rm -v ~:/homelocal xubuntu-tc:1.0 script=<the-path-to-your-script>
    ```

## Features

This is the minimal desktop test based on *ubuntu:16.04* image, it has:

* **Fully installed xfce4 desktop**: it has most of the useful plug-ins for xfce4 desktop. While libreoffice and texlive are **not** installed.
* **Fully inherit the base image**: some base image may already have the entrypoint script. We provide options for including the the entry-script of base image.
* **Modern VNC server**: it contains [tigervncserver][tigervnc], which is a modern VNC server and could provide more features than tightvncserver and vnc4server, like cutomizing display settings, fully implemented animated cursor and shadow effects.
* **Compatible for multiple Ubuntu versions**: including Ubuntu 16.04, 18.04 and 20.04.
* **Useful apps**: including nomacs, notepadqq, visual studio code, peazip, okular, smplayer and chrome.

## Update records

### ver 1.1 @ 1/10/2021

1. Support Ubuntu 20.04.
2. Fix the font issues.
3. Finish all testings for Ubuntu 16.04, 18.04 and 20.04.

Testing report:

> This docker file has been tested sucessfully on:
>
> * `nvcr.io/nvidia/pytorch:20.12-py3` (`Ubuntu 20.04`, `python 3.8`)
> * `nvcr.io/nvidia/cuda:11.1-cudnn8-runtime-ubuntu20.04` (`Ubuntu 20.04`)
> * `nvcr.io/nvidia/pytorch:20.11-py3` (`Ubuntu 18.04`, `python 3.6`)
> * `nvcr.io/nvidia/tensorflow:19.03-py3` (`Ubuntu 16.04`, `python 3.5`)

### ver 1.0 @ 12/18/2020

Re-craft this dockerfile.

### ver 1.0 @ 20181201

Create the dockerfile branch.

[tigervnc]:https://github.com/TigerVNC/tigervnc "TigerVNC"