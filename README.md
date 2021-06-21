# Dockerfile Collection for DGX-230

## XUbuntu (Minimal)

The XUbuntu (Minimal) image is only equipped with required apps, light-weighted desktop plugins, some limited extra apps (see [features](#features).

This dockerfile is mainly used for developing the image, especially used for debugging the features of the desktop itself.

### Online building

If you do not want to change the contents of the dockerfile, you could use such command to build the image:

```Bash
docker build -t xminimal:1.0 https://github.com/cainmagi/Dockerfiles.git#xubuntu-minimal
```

This image is compatible for Ubuntu 16.04, 18.04 and 20.04. Please check your base image and confirm that the Ubuntu inside the image is compatible with this dockerfile. Most of the NVIDIA images could be used for building this desktop. For example:

* Start from `pytorch 1.9.0a` image:

  ```bash
  docker build -t xminimal-tc:1.0 --build-arg BASE_IMAGE=nvcr.io/nvidia/pytorch:21.05-py3 --build-arg BASE_LAUNCH=/usr/local/bin/nvidia_entrypoint.sh https://github.com/cainmagi/Dockerfiles.git#xubuntu-minimal
  ```

There are 3 available options:

| Option  | Description | Default |
| :-----: | ----------- | ------- |
| `BASE_IMAGE` | The base image for building this desktop image. | `nvcr.io/nvidia/pytorch:21.05-py3` |
| `BASE_LAUNCH` | The entrypoint script from the base image. If there is no entry script, please use`""`. | `/usr/local/bin/nvidia_entrypoint.sh` |
| `WITH_CHINESE` | If set, the image would be built with Chinese support for vscode, sublime and codeblocks. | `true` |
| `ADDR_PROXY` | Set the proxy address pointing to `localhost`. If specified, this value should be a full address. (Experimental feature ::) | `unset` |

To find your launch script of your base image, use

```bash
docker inspect <your-base-image>:<tag>
```

### Offline building

Otherwise, you need to clone the branch firstly:

```Bash
git clone --single-branch -b xubuntu-minimal https://github.com/cainmagi/Dockerfiles.git xminimal
```

After that, run such command to build the image:

```Bash
docker build -t xminimal:1.0 xminimal
```

where `xminimal` is the folder of the corresponding branch. The options in online building examples could be also used for offline building.

### Launching

* By built-in `noVNC`: In default mode, you just need to launch the built image by:

  ```bash
  docker run --gpus all -it --rm -v ~:/homelocal -p 6080:6080 xminimal:1.0
  ```

  It is equivalent to use `--vnc` or not in the above command. However, if you have saved the image in other modes before, you may need this flag to force the image to enter the VNC mode. The `--vnc` option is required when you need to force the image to switch to VNC mode. The following command would force the `vnc` launched by `root` mode.

  ```bash
  docker run --gpus all -it --rm -v ~:/homelocal -p 6080:6080 xminimal:1.0 --root
  ```

  In current version, users could use either `http` to get access to the unencrypted noVNC session or `https` to get access to the ssl-encrypted noVNC session. For users who open the encrypted session firstly, they may need to add the noVNC site into the trusted list.

* By external VNC viewer: If you have installed a VNC viewer on your client side, and want to connect the VNC server of the image directly, please use:

  ```bash
  docker run --gpus all -it --rm -v ~:/homelocal -p 5901:5901 xminimal:1.0
  ```

  The `root` mode could be also applied here.

* By `BASH`: If you want to enter the command line but do not start the desktop, please use

  ```bash
  docker run --gpus all -it --rm -v ~:/homelocal xminimal:1.0 --bash
  ```

* By any script: If you want run any script inside the docker for only one time, please use

  ```bash
  docker run --gpus all -it --rm -v ~:/homelocal xminimal:1.0 script=<the-path-to-your-script>
  ```

## Features

This is the minimal desktop test based on `ubuntu` `16.04`, `18.04` or `20.04` image, it has:

* **Fully installed xfce4 desktop**: it has most of the useful plug-ins for xfce4 desktop. While libreoffice and texlive are **not** installed.
* **Fully inherit the base image**: some base image may already have the entrypoint script. We provide options for including the the entry-script of base image.
* **Modern VNC server**: it contains [tigervncserver][tigervnc], which is a modern VNC server and could provide more features than tightvncserver and vnc4server, like cutomizing display settings, fully implemented animated cursor and shadow effects.
* **Compatible for multiple Ubuntu versions**: including Ubuntu 16.04, 18.04 and 20.04.
* **Limited apps**: the extra app list is shown as follows:
  * Python 3 and Python 2 (if Ubuntu `<=16.04`).
  * Firefox; Chrome (if Ubuntu `==20.04`) or Chromium (otherwise).
  * GEdit, GVim, Mousepad (for text editing); Okular (for PDF viewing); Fcitx and CJK fonts.
* **Multiple launching method**: including VNC server, bash and arbitrary script mode.
* **Chinese language support**: for some apps including Chrome, Firefox.

## Update records

### ver 1.0 @ 6/21/2021

1. Create this minimal dockerfile.
2. Fix a bug of dbus, this fixing would make the screen saver work.

[tigervnc]: https://github.com/TigerVNC/tigervnc
