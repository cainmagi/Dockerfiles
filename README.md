# Dockerfile Collection for DGX-230

## XUbuntu

### Online building

If you do not want to change the contents of the dockerfile, you could use such command to build the image:

```Bash
docker build -t xubuntu:1.0 https://github.com/cainmagi/Dockerfiles.git#xubuntu
```

This image is compatible for Ubuntu 16.04, 18.04 and 20.04. Please check your base image and confirm that the Ubuntu inside the image is compatible with this dockerfile.

We provide 3 examples:

* Start from `pytorch 1.8.0a` image:

  ```bash
  docker build -t xubuntu-tc:1.0 --build-arg BASE_IMAGE=nvcr.io/nvidia/pytorch:20.12-py3 --build-arg BASE_LAUNCH=/usr/local/bin/nvidia_entrypoint.sh --build-arg JLAB_VER=2 https://github.com/cainmagi/Dockerfiles.git#xubuntu
  ```

* Start from `cuda 11.1` image:

  ```bash
  docker build -t xubuntu-cuda:1.0 --build-arg BASE_IMAGE=nvcr.io/nvidia/cuda:11.1-cudnn8-runtime-ubuntu20.04 --build-arg BASE_LAUNCH="" --build-arg JLAB_VER=2 https://github.com/cainmagi/Dockerfiles.git#xubuntu
  ```

* Start from `tensorflow 1.13.1` image:

  ```bash
  docker build -t xubuntu-tf:1.0 --build-arg BASE_IMAGE=nvcr.io/nvidia/tensorflow:19.03-py3 --build-arg BASE_LAUNCH=/usr/local/bin/nvidia_entrypoint.sh --build-arg JLAB_VER=2 https://github.com/cainmagi/Dockerfiles.git#xubuntu
  ```

There are 3 available options:

| Option  | Description | Default |
| :-----: | ----------- | ------- |
| `BASE_IMAGE` | The base image for building this desktop image. | `nvcr.io/nvidia/pytorch:20.12-py3` |
| `BASE_LAUNCH` | The entrypoint script from the base image. If there is no entry script, please use`""`. | `/usr/local/bin/nvidia_entrypoint.sh` |
| `JLAB_VER` | The version of the Jupyter Lab to be installed. Could be`1`, `2`, `3` or `unset`. If use `unset`, nothing would be installed if there is already a Jupyter Lab. | `unset` |
| `JLAB_EXTIERS` | The to-be-installed extra extensions for the Jupyter Lab. If`JLAB_VER` is `unset`, nothing would be installed. To view details about which extensions would be installed, see [here](https://github.com/cainmagi/Dockerfiles/tree/jupyterlab#features). | `2` |
| `WITH_CHINESE` | If set, the image would be built with Chinese support for vscode, sublime and codeblocks. | `true` |
| `WITH_EXTRA_APPS` | The installed extra applications. Each character represents an app or several apps. For example,`go` represents fully installing `GIMP`, `LibreOffice` and `Thunderbird`. More details could be referred in the following table. | `go` |

Here we show the list of extra apps:

|  Code   | Description |
| :-----: | ----------- |
| `p` | [`PyCharm`](https://www.jetbrains.com/help/pycharm/installation-guide.html) |
| `g` | [`GIMP`](https://www.gimp.org/downloads) |
| `x` | [`TeXLive`](https://tug.org/texlive) + [`TeXstudio`](https://www.texstudio.org) |
| `n` | [`Nautilus`](https://github.com/GNOME/nautilus) + [`Nemo`](https://github.com/linuxmint/nemo) |
| `o` | [`LibreOffice`](https://www.libreoffice.org) + [`Thunderbird`](https://www.thunderbird.net) |
| `a` | [`Atom`](https://flight-manual.atom.io/getting-started/sections/installing-atom) + [`Nuclide`](https://nuclide.io/docs/editor/setup) |
| `e` | [`GNU Emacs`](https://www.gnu.org/software/emacs/download.html#gnu-linux) |

To find your launch script of your base image, use

```bash
docker inspect <your-base-image>:<tag>
```

### Offline building

Otherwise, you need to clone the branch firstly:

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

  It is equivalent to use `--vnc` or not in the above command. However, if you have saved the image in other modes before, you may need this flag to force the image to enter the VNC mode. The `--vnc` option is required when you need to force the image to switch to VNC mode. The following command would force the `vnc` launched by `root` mode.

  ```bash
  docker run --gpus all -it --rm -v ~:/homelocal -p 6080:6080 xubuntu:1.0 --root
  ```

  In current version, users could use either `http` to get access to the unencrypted noVNC session or `https` to get access to the ssl-encrypted noVNC session. For users who open the encrypted session firstly, they may need to add the noVNC site into the trusted list.
* By external VNC viewer: If you have installed a VNC viewer on your client side, and want to connect the VNC server of the image directly, please use:

  ```bash
  docker run --gpus all -it --rm -v ~:/homelocal -p 5901:5901 xubuntu:1.0
  ```

  The `root` mode could be also applied here.
* By `Jupyter Lab`: If you want to launch the Jupyter Lab but do not start the desktop, please use

  ```bash
  docker run --gpus all -it --rm -v ~:/homelocal -p 6080:6080 xubuntu:1.0 --jlab jlab_password=openjupyter jlab_rootdir=/homelocal
  ```

  The `jlab_password` would override the default random token. The `jlab_rootdir` is the root folder of the launched jupyter lab. If not set `jlab_rootdir`, the default root folder would be `/homelocal`. The `--jlab` option is required when you need to force the image to switch to Jupyter Lab mode.
* By `BASH`: If you want to enter the command line but do not start the desktop, please use

  ```bash
  docker run --gpus all -it --rm -v ~:/homelocal xubuntu:1.0 --bash
  ```
* By any script: If you want run any script inside the docker for only one time, please use

  ```bash
  docker run --gpus all -it --rm -v ~:/homelocal xubuntu:1.0 script=<the-path-to-your-script>
  ```

## Features

This is the minimal desktop test based on `ubuntu` `16.04`, `18.04` or `20.04` image, it has:

* **Fully installed xfce4 desktop**: it has most of the useful plug-ins for xfce4 desktop. While libreoffice and texlive are **not** installed.
* **Fully inherit the base image**: some base image may already have the entrypoint script. We provide options for including the the entry-script of base image.
* **Modern VNC server**: it contains [tigervncserver][tigervnc], which is a modern VNC server and could provide more features than tightvncserver and vnc4server, like cutomizing display settings, fully implemented animated cursor and shadow effects.
* **Compatible for multiple Ubuntu versions**: including Ubuntu 16.04, 18.04 and 20.04.
* **Useful apps**: including nomacs, notepadqq, visual studio code, peazip, okular, smplayer and chrome.
* **Fully installed Jupyter Lab**: if user needs, a full Jupyter Lab with several extensions could be installed, the details could be checked [here][jlab].
* **Multiple launching method**: including VNC server, jupyterlab, bash and arbitrary script mode.
* **Chinese language support**: for some apps including vscode, sublime, codeblocks.

## Update records

### ver 1.5 @ 4/10/2021

The plan for the next version.

1. Enhance the launchers of system menu and panels.
2. Set the user as `xubuntu`, and provide the `--root` mode.
3. Make python version auto-detected, which means `XUBUNTU_COMPAT` has been removed.
4. Add options for installing some extra apps, like PyCharm and GIMP.
5. Enhance the VNC support by [OpenSSL entryption](https://github.com/novnc/websockify#encrypted-websocket-connections-wss).
6. Upgrade the [Jupyter Lab script](https://github.com/cainmagi/Dockerfiles/tree/jlab-v1.2).
7. Add some [themes](https://github.com/cainmagi/Dockerfiles/releases/tag/xubuntu-v1.5-u20.04).
8. Fix the [compatibility problem](https://github.com/pypa/pip/issues/9500) caused by `pip 21.0`.
9. Fix small bugs, related to `nvm` path, `root` authority, and `detach` script.
10. Fix small bugs, related to `jlab` path and the authority of creating SSL certificate.

### ver 1.4 @ 1/17/2021

1. Arrange the theme pack installations.
2. Add fully supported Jupyter Lab installation.
3. Adjust the usage of some options.
4. Add some packages for the desktop.
5. Correct the format of some launchers.

### ver 1.3 @ 1/13/2021

1. Re-craft the icons and themes for `ubuntu 20.04`.
2. Add `gcc` and `gfortran` supports for building the image.
3. Add some packages for the desktop.
4. Add check for `ubuntu` version.
5. Add meta-data in the dockerfile.

### ver 1.2 @ 1/12/2021

1. Add extra Chinese supports for some packages.
2. Add vscode package installation script.
3. Add exposed ports (`5901`, `6080`).
4. Add `Jupyter Lab` supports.

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

[tigervnc]: https://github.com/TigerVNC/tigervnc
[jlab]: https://github.com/cainmagi/Dockerfiles/tree/jupyterlab
