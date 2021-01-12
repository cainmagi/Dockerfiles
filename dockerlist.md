# Dockerfile Collection for DGX-230

To get back to the main page, click [here](./index).

## Documentation for currently built images

> Updated on 1/12/2021

Here I am maintaining a list of currently built docker images on our DGX-230. All of them are built based on:

[xubuntu branch](https://github.com/cainmagi/Dockerfiles/tree/xubuntu)

### Usage: interactive mode

The basic usage for any of the following image could be divided into 4 cases:

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
    docker run --gpus all -it --rm -v ~:/homelocal xubuntu:1.0 --bash
    ```

* By any script: If you want run any script inside the docker for only one time, please use

    ```bash
    docker run --gpus all -it --rm -v ~:/homelocal xubuntu:1.0 script=<the-path-to-your-script>
    ```
    
> Note:
> It is not required to launch noVNC separately for the newly relesed images. Because the noVNC has been built-in in the images. If we use `-p xxxx:6080` to launch our image, we only need to open our browser and use the following address:
> http://<dgx-230-ip>:xxxx/vnc.html?host=<dgx-230-ip>&port=xxxx
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
> The backend mode should not be launched by the released images directly, because those images would require users to set password when firstly opening the container. Users should set thier passwords, save the image separately and then could use the backend mode to launch their own images.

### Usage: save the image

When you want to save your image, follow the instructions below:

1. Logout from your desktop by clicking the menu on the right top corner of the desktop.
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
    ```
    root@<container-id>: # 
    ```
5. **Tips**: If you are saving a container launched with options, you need to use the following command to save the image with the options flushed:
    ```bash
    docker commit --change='CMD [""]' <container-id> <image-name>:<tag>
    ```

### Docker image info list

Here we would show the list of currently built images. Please check each item to find the information of any specific image.

#### xubuntu-tf2:1.0

**X-Ubuntu Tensorflow 2**

The xubuntu tensorflow `2.x` image. Currently, the tensorflow version is `2.3.1`.

This image is built based on the following command:

```bash
docker build -t xubuntu-tf2:1.0 --build-arg BASE_IMAGE=nvcr.io/nvidia/tensorflow:20.12-tf2-py3 --build-arg BASE_LAUNCH=/usr/local/bin/nvidia_entrypoint.sh https://github.com/cainmagi/Dockerfiles.git#xubuntu
```

This image contains:

* `Tensorflow 2.3.1`
* `Python 3.8.5`
* `xubuntu` desktop with apps
* `Ubuntu 20.04`

#### xubuntu-tf:1.0

**X-Ubuntu Tensorflow 1.13.1**

The xubuntu tensorflow `1.13.1` image.

This image is built based on the following command:

```bash
docker build -t xubuntu-tf:1.0 --build-arg BASE_IMAGE=nvcr.io/nvidia/tensorflow:19.03-py3 --build-arg BASE_LAUNCH=/usr/local/bin/nvidia_entrypoint.sh --build-arg NOVNC_COMPAT=true https://github.com/cainmagi/Dockerfiles.git#xubuntu
```

This image contains:

* `Tensorflow 1.13.1`
* `Python 3.5.2`
* `xubuntu` desktop with apps
* `Ubuntu 16.04`

#### xubuntu-tc:1.0

**X-Ubuntu PyTorch**

The xubuntu latest PyTorch image. Currently, the PyTorch version is `1.8.0a0+1606899`.

This image is built based on the following command:

```bash
docker build -t xubuntu-tc:1.0 --build-arg BASE_IMAGE=nvcr.io/nvidia/pytorch:20.12-py3 --build-arg BASE_LAUNCH=/usr/local/bin/nvidia_entrypoint.sh https://github.com/cainmagi/Dockerfiles.git#xubuntu
```

This image contains:

* `PyTorch 1.8.0a`
* `Python 3.8.5`
* `xubuntu` desktop with apps
* `Ubuntu 20.04`

#### xubuntu-tc1.0:1.0

**X-Ubuntu PyTorch 1.0**

The xubuntu PyTorch 1.0 image. Currently, the PyTorch version is `1.0.0a0+056cfaf`.

This image is built based on the following command:

```bash
docker build -t xubuntu-tc1.0:1.0 --build-arg BASE_IMAGE=nvcr.io/nvidia/pytorch:19.01-py3 --build-arg BASE_LAUNCH=/usr/local/bin/nvidia_entrypoint.sh https://github.com/cainmagi/Dockerfiles.git#xubuntu
```

This image contains:

* `PyTorch 1.0.0a`
* `Python 3.6.7`
* `xubuntu` desktop with apps
* `Ubuntu 16.04`

#### xubuntu-matlab:r2020b

**X-Ubuntu MATLAB R2020b**

The xubuntu MATLAB `R2020b` image.

This image is built based on the [`xubuntu-tf2:1.0`](#xubuntu-tf210) image. The MATLAB and other packages are installed by manually. Note that a license is needed if you want to launch MATLAB.

This image contains:

* `MATLAB R2020b`
* `Tensorflow 2.3.1`
* `PyTorch 1.7.1`
* `Python 3.8.5`
* `xubuntu` desktop with apps
* `Ubuntu 20.04`
