# Dockerfiles

A collection of my personal customized Dockerfiles.

## Deformable-DETR

This image is only used for building and testing the usablity of [Deformable-DETR](https://github.com/fundamentalvision/Deformable-DETR).

In this image, we have the following packages installed:

* PyTorch (`torch`)
* Transformers with PyTorch (`transformers[torch]`)
* MultiScaleDeformableAttention (`MultiScaleDeformableAttention`)

## Pre-built images

Some pre-built images are available on DockerHub:

https://hub.docker.com/r/cainmagi/deformable-detr

## Usage

Run the following command to build the image:

```sh
docker build -t deformable-detr:debian12 https://github.com/cainmagi/Dockerfiles.git#Deformable-DETR
```

Note that the GPU is not available during `docker build`. Therefore, during `docker build`,
we have not build the Deformable-DETR yet. To make the image completely built, we need
to run the container manually,

```sh
docker run --gpus all -it --rm --shm-size=1g deformable-detr:debian12 bash
```

In the container, run

```sh
cd /opt/deformable-detr
bash ./build.sh
```

and commit the image by the `docker commit`. After that, we can expect that the image can be used normally.

After commiting the image, use the following command to relaunch a container shell:

```sh
docker run --gpus all -it --rm --shm-size=1g deformable-detr:debian12 bash
```

> [!CAUTION]
> If you do not add <code>bash</code> at the end of the command, the container will be launched as Python.

Inside the image, users can get the built packages in `/opt/deformable-detr/models/ops`.

This package has been installed globally in the image.

### Test with Python

To test the build package, you can use interactive python by

```sh
docker run --gpus all -it --rm --shm-size=1g deformable-detr:debian12 python3
```

and run

```python
import torch
import MultiScaleDeformableAttention
```

> [!CAUTION]
> You have to make `torch` imported first. Otherwise, you will get an ImportError: `libc10.so`, see
> https://stackoverflow.com/a/65710714/8266012

## Supported options

It is possible to use a different `BASE_IMAGE` if you want to switch to a different OS:

* Debian (default), CUDA 12.4:
  
  ```sh
  docker build -t deformable-detr:debian12 --build-arg BASE_IMAGE=cainmagi/cuda:debian12-cu124 https://github.com/cainmagi/Dockerfiles.git#Deformable-DETR
  ``` 

* Ubuntu 24.04, CUDA 12.4:

  ```sh
  docker build -t deformable-detr:ubuntu2404 --build-arg BASE_IMAGE=nvcr.io/nvidia/pytorch:24.12-py3 https://github.com/cainmagi/Dockerfiles.git#Deformable-DETR
  ```
