# Dockerfile Collection for DGX-230

To get back to the main page, click [here](./index).

## Documentation for currently built images (xUbuntu)

> Updated on 2/3/2021

Here I am maintaining a list of currently built docker images on our DGX-230. Most of them are built based on:

[xubuntu branch][git-xubuntu]

### Usage: interactive mode

The basic usage for any of the following image could be divided into 4 cases:

* By built-in `noVNC`: In default mode, you just need to launch the built image by:

    ```bash
    docker run --gpus all -it --rm -v ~:/homelocal -p 6080:6080 xubuntu:1.0
    ```

    The above command is the equivalent to

    ```bash
    docker run --gpus all -it --rm -v ~:/homelocal -p 6080:6080 xubuntu:1.0 --vnc
    ```

    This option would force the image to launch the VNC server.

    The following command would force the VNC launched by `root` mode.

    ```bash
    docker run --gpus all -it --rm -v ~:/homelocal -p 6080:6080 xubuntu:1.0 --root
    ```

    In current version, users could use either `http` to get access to the unencrypted noVNC session or `https` to get access to the ssl-encrypted noVNC session. For users who open the encrypted session firstly, they may need to add the noVNC site into the trusted list. Here we show an example of how to do that in Chrome. First we need to add `https://` at the beginning of our accessing address. Then we could check the following figures:
    
    | 登录有SSL保护的noVNC | Login with noVNC protected by SSL |
    | :-----: | :-----: |
    | ![](./display/example-ssl-hans.png) | ![](./display/example-ssl-eng.png) |

* By external VNC viewer: If you have installed a VNC viewer on your client side, and want to connect the VNC server of the image directly, please use:

    ```bash
    docker run --gpus all -it --rm -v ~:/homelocal -p 5901:5901 xubuntu:1.0
    ```

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

> Note:
>
> It is not required to launch noVNC separately for the newly relesed images. Because the noVNC has been built-in in the images. If we use `-p xxxx:6080` to launch our image, we only need to open our browser and use the following address:
>
> http://<dgx-230-ip>:xxxx/vnc.html?host=<dgx-230-ip>&port=xxxx
>
> If you want to connect the VNC in encrypt mode, please use:
>
> https://<dgx-230-ip>:xxxx/vnc.html?host=<dgx-230-ip>&port=xxxx
>
> Here is a tip: the configs after `vnc.html` could be omitted if you only need to get access to your own desktop.

### Usage: backend mode

If you want your container run on the backend rather than interactively, please change `-it` by `-dit`. However, this option should be only used when you are working with programs running on the backend, like VNC server. For example:

```bash
docker run --gpus all -dit --rm -v ~:/homelocal -p 6080:6080 xubuntu:1.0
```

```bash
docker run --gpus all -dit --rm -v ~:/homelocal -p 5901:5901 xubuntu:1.0
```

In this case, unless you use `docker kill` or `docker stop` to terminate your container, the container would be kept running.

> Note:
>
> The backend mode should not be launched by the released images directly, because those images would require users to set password when firstly opening the container. Users should set their passwords, save the image separately and then could use the backend mode to launch their own images.

### Usage: save the image

When you want to save your image, follow the instructions below:

1. *(This step is confirmed to be unnecessary.)* <del>Logout from your desktop by clicking the menu on the right top corner of the desktop.</del>
2. Hit <kbd>Ctrl</kbd>+<kbd>C</kbd> on your interactive terminal. This operation would terminate noVNC. You will see the `websockify` of noVNC is interrupted.
3. Use the following command to terminate the VNC server:

    ```bash
    tigervncserver -kill :1
    ```

4. Open another terminal. In that terminal, you should be outside of the image, use the following command to save your current container as a new image:

    ```bash
    docker commit <container-id> <image-name>:<tag>
    ```

    The `<image-name>` and `<tag>` could be determined by yourself. However, `<container-id>` should be found on your container-side terminal, it should follow the user name of your bash, like:

    ```no
    root@<container-id>: # 
    ```

> Note 1:
> If you are saving a container launched with options (for example, `docker run ... xubuntu:1.0 --bash`), you need to use the following command to save the image with the options flushed:
>
> ```bash
> docker commit --change='CMD [""]' <container-id> <image-name>:<tag>
> ```
>
> If you do not add the option, your launching options would be remembered in your new image.

> Note 2:
>
> In **any** case when you launch your container by backend mode (with option `-dit`), you should not commit your image, because you could not kill your `tigervncserver` without interactive shell.

## Documentation for currently built images (Jupyter Lab)

> Updated on 1/16/2021

Here I am maintaining a list of currently built docker images on our DGX-230. Most of them are built based on:

[jupyterlab branch][git-jlab]

### Usage: interactive mode

The basic usage for any of the following image could be divided into 4 cases:

* By built-in `Jupyter Lab`: In default mode, you just need to launch the built image by:

    ```bash
    docker run --gpus all -it --rm -v ~:/homelocal jlab:1.0 -p 6080:6080 password=openjupyter rootdir=/homelocal
    ```

    The `password` would override the default random token. The `rootdir` is the root folder of the launched jupyter lab. If not set `rootdir`, the default root folder would be `/homelocal`. You could also add the `--jlab` flag. The `--jlab` flag is required when you need to force the image to switch to Jupyter Lab mode.

* By `BASH`: If you want to enter the command line but do not start the desktop, please use

    ```bash
    docker run --gpus all -it --rm -v ~:/homelocal jlab:1.0 --bash
    ```

* By any script: If you want run any script inside the docker for only one time, please use

    ```bash
    docker run --gpus all -it --rm -v ~:/homelocal jlab:1.0 script=<the-path-to-your-script>
    ```

> Note:
>
> If you start your container with a configured password, you could open the following address directly and fill your password:
>
> http://<dgx-230-ip>:xxxx
>
> When you start your container without configuring the password, you would still be asked for a token, which would be shown in your terminal. In this case, we could use this address to skip the step for filling the token:
>
> http://<dgx-230-ip>:xxxx/?token=<token-from-the-terminal>

### Usage: backend mode

If you want your container run on the backend rather than interactively, please change `-it` by `-dit`. However, this option could be directly used for the released image. You do not need to save your own image first. For example:

```bash
docker run --gpus all -dit --rm -v ~:/homelocal -p 6080:6080 jlab:1.0 password=....
```

In this case, unless you use `docker kill` or `docker stop` to terminate your container, the container would be kept running.

> Note:
>
> When starting your container without setting the password, **do not** use the backend mode, because you will be asked for a token instead of the password, but you could only find the token from the terminal in this case.

### Usage: save the image

When you want to save your image, follow the instructions below:

1. Hit <kbd>Ctrl</kbd>+<kbd>C</kbd> on your interactive terminal. This operation would terminate `Jupyter Lab`.
2. Open another terminal. In that terminal, you should be outside of the image, use the following command to save your current container as a new image:

    ```bash
    docker commit <container-id> <image-name>:<tag>
    ```

    The `<image-name>` and `<tag>` could be determined by yourself. However, `<container-id>` should be found on your container-side terminal, it should follow the user name of your bash, like:

    ```no
    root@<container-id>: # 
    ```

> Note 1:
> If you are saving a container launched with options (for example, `docker run ... jlab:1.0 --bash`), you need to use the following command to save the image with the options flushed:
>
> ```bash
> docker commit --change='CMD [""]' <container-id> <image-name>:<tag>
> ```
>
> If you do not add the option, your launching options would be remembered in your new image.

> Note 2:
>
> In **any** case when you launch your container by backend mode (with option `-dit`), you should not commit your image, because you could not kill your `jupyterlab` without interactive shell.

## Docker image info list

Here we would show the list of currently built images. Please check each item to find the information of any specific image.

### xUbuntu

The following images are build based on [xubuntu branch][git-xubuntu].

-----

#### nvcr.io/uoh053018/xubuntu-tf:1.5-2.3.1

**X-Ubuntu Tensorflow 2**

The xubuntu tensorflow `2.x` image. Currently, the tensorflow version is `2.3.1`.

This image is built based on the following command:

```bash
docker build -t nvcr.io/uoh053018/xubuntu-tf:1.5-2.3.1 --build-arg BASE_IMAGE=nvcr.io/nvidia/tensorflow:20.12-tf2-py3 --build-arg BASE_LAUNCH=/usr/local/bin/nvidia_entrypoint.sh --build-arg JLAB_VER=2 --build-arg WITH_EXTRA_APPS=pgo https://github.com/cainmagi/Dockerfiles.git#xubuntu-v1.5-u20.04
```

This image has been also uploaded to our NGC account, check [here][nv-tf] for viewing details. With our NVIDIA account, you could pull the image directly by:

```bash
docker pull nvcr.io/uoh053018/xubuntu-tf:1.5-2.3.1
```

This image contains:

* `Tensorflow 2.3.1`
* `Python 3.8.5`
* `xubuntu` desktop with apps
* `Jupyter Lab 2.2.9`
* `PyCharm 2020.3.3`
* `Ubuntu 20.04`

-----

#### nvcr.io/uoh053018/xubuntu-tf:1.5-1.13.1

**X-Ubuntu Tensorflow 1.13.1**

The xubuntu tensorflow `1.x` image. Currently, the tensorflow version is `1.13.1`.

This image is built based on the following command:

```bash
docker build -t nvcr.io/uoh053018/xubuntu-tf:1.5-1.13.1 --build-arg BASE_IMAGE=nvcr.io/nvidia/tensorflow:19.03-py3 --build-arg BASE_LAUNCH=/usr/local/bin/nvidia_entrypoint.sh --build-arg JLAB_VER=2 --build-arg WITH_EXTRA_APPS=go https://github.com/cainmagi/Dockerfiles.git#xubuntu-v1.5-u20.04
```

This image has been also uploaded to our NGC account, check [here][nv-tf] for viewing details. With our NVIDIA account, you could pull the image directly by:

```bash
docker pull nvcr.io/uoh053018/xubuntu-tf:1.5-1.13.1
```

This image contains:

* `Tensorflow 1.13.1`
* `Python 3.5.2`
* `xubuntu` desktop with apps
* `Jupyter Lab 2.2.9`
* `Ubuntu 16.04`

-----

#### nvcr.io/uoh053018/xubuntu-tc:1.5-1.8.0

**X-Ubuntu PyTorch**

The xubuntu latest PyTorch image. Currently, the PyTorch version is `1.8.0a0+1606899`.

This image is built based on the following command:

```bash
docker build -t nvcr.io/uoh053018/xubuntu-tc:1.5-1.8.0 --build-arg BASE_IMAGE=nvcr.io/nvidia/pytorch:20.12-py3 --build-arg BASE_LAUNCH=/usr/local/bin/nvidia_entrypoint.sh --build-arg JLAB_VER=2 --build-arg WITH_EXTRA_APPS=pgo https://github.com/cainmagi/Dockerfiles.git#xubuntu-v1.5-u20.04
```

This image has been also uploaded to our NGC account, check [here][nv-tc] for viewing details. With our NVIDIA account, you could pull the image directly by:

```bash
docker pull nvcr.io/uoh053018/xubuntu-tc:1.5-1.8.0
```

This image contains:

* `PyTorch 1.8.0a0+1606899`
* `Python 3.8.5`
* `xubuntu` desktop with apps
* `Jupyter Lab 2.2.9`
* `PyCharm 2020.3.3`
* `Ubuntu 20.04`

-----

#### nvcr.io/uoh053018/xubuntu-tc:1.5-1.0.0

**X-Ubuntu PyTorch 1.0**

The xubuntu PyTorch 1.0 image. Currently, the PyTorch version is `1.0.0a0+056cfaf`.

This image is built based on the following command:

```bash
docker build -t nvcr.io/uoh053018/xubuntu-tc:1.5-1.0.0 --build-arg BASE_IMAGE=nvcr.io/nvidia/pytorch:19.01-py3 --build-arg BASE_LAUNCH=/usr/local/bin/nvidia_entrypoint.sh --build-arg JLAB_VER=2 --build-arg WITH_EXTRA_APPS=pgo https://github.com/cainmagi/Dockerfiles.git#xubuntu-v1.5-u20.04
```

This image has been also uploaded to our NGC account, check [here][nv-tc] for viewing details. With our NVIDIA account, you could pull the image directly by:

```bash
docker pull nvcr.io/uoh053018/xubuntu-tc:1.5-1.0.0
```

This image contains:

* `PyTorch 1.0.0a0+056cfaf`
* `Python 3.6.7`
* `xubuntu` desktop with apps
* `Jupyter Lab 2.2.9`
* `PyCharm 2020.3.3`
* `Ubuntu 16.04`

-----

#### nvcr.io/uoh053018/xubuntu-matlab:r2020b

**X-Ubuntu MATLAB R2020b**

The xubuntu MATLAB `R2020b` image.

This image is built based on the [`xubuntu-tf:1.4-2.3.1`](#nvcriouoh053018xubuntu-tf14-231) image. The MATLAB and other packages are installed by manually. Note that a license is needed if you want to launch MATLAB.

Because the layer of installing matlab is too large, we have not found a method for pushing the image to our NGC account. Maybe we could solve this problem in the future.

This image contains:

* `MATLAB R2020b`
* `Tensorflow 2.3.1`
* `PyTorch 1.7.1`
* `Python 3.8.5`
* `xubuntu` desktop with apps
* `Jupyter Lab 2.2.9`
* `Ubuntu 20.04`
* `Gimp, PyCharm`

-----

#### nvcr.io/uoh053018/xubuntu-matlab-xp:r2020b

**X-Ubuntu MATLAB R2020b (Windows XP Theme)**

This image is configured based on [`xubuntu-matlab:r2020b`](#nvcriouoh053018xubuntu-matlabr2020b). All the installed packages are the same. The only difference is that it is switched to a Windows XP theme. This image is an example for showing how to make the xUbuntu like Windows.

-----

### Jupyter Lab

The following images are built based on [jupyterlab branch][git-jlab]. Actually, the xUbuntu images has been **already equipped with** `Jupyter Lab`. However, the versions of all of those JLab releases are `2.2.9`. Here we provide images with `Jupyter Lab 3.0.6`. The JLab 3 has just quitted the pre-release stage for not very long. Currently, the newest version is `3.0.6`. It means most extensions designed for JLab 1 or 2 would not support JLab 3. However, there are also some useful extensions only supporting JLab 3, like Chinese localization, variable inspector and language linter. These images are provided for who want to try the newest Jupyter Lab. All of them do not support desktop applications.

-----

#### jlab3-tf:2.3.1

**Jupyter Lab 3 and Tensorflow 2**

The xubuntu tensorflow `2.x` image. Currently, the tensorflow version is `2.3.1`.

This image is built based on the following command:

```bash
docker build -t jlab3-tf:2.3.1 --build-arg BASE_IMAGE=nvcr.io/nvidia/tensorflow:20.12-tf2-py3 --build-arg BASE_LAUNCH=/usr/local/bin/nvidia_entrypoint.sh --build-arg JLAB_VER=3 --build-arg JLAB_EXTIERS=2 https://github.com/cainmagi/Dockerfiles.git#jlab-v1.2
```

This image contains:

* `Tensorflow 2.3.1`
* `Python 3.8.5`
* `Jupyter Lab 3.0.6`
* `Ubuntu 20.04`

-----

#### jlab3-tc:1.0

**Jupyter Lab 3 and PyTorch**

The xubuntu latest PyTorch image. Currently, the PyTorch version is `1.8.0a0+1606899`.

This image is built based on the following command:

```bash
docker build -t jlab3-tc:1.8.0 --build-arg BASE_IMAGE=nvcr.io/nvidia/pytorch:20.12-py3 --build-arg BASE_LAUNCH=/usr/local/bin/nvidia_entrypoint.sh --build-arg JLAB_VER=3 --build-arg JLAB_EXTIERS=2 https://github.com/cainmagi/Dockerfiles.git#jlab-v1.2
```

This image contains:

* `PyTorch 1.8.0a`
* `Python 3.8.5`
* `Jupyter Lab 3.0.6`
* `Ubuntu 20.04`

-----

[git-xubuntu]:https://github.com/cainmagi/Dockerfiles/tree/xubuntu "xUbuntu"
[git-jlab]:https://github.com/cainmagi/Dockerfiles/tree/jupyterlab "Jupyter Lab"
[nv-tf]:https://ngc.nvidia.com/containers/uoh053018:xubuntu-tf "X-Ubuntu Tensorflow"
[nv-tc]:https://ngc.nvidia.com/containers/uoh053018:xubuntu-tc "X-Ubuntu PyTorch"
