# Dockerfiles

A collection of my personal customized Dockerfiles.

## CUDA

The customized scripts for building Docker images with CUDA toolkit locally deployed.

* Why do we need this image?
  
  * The reason is that the image contains the CUDA dev files (`/usr/local/cuda`). Developers may need these files to build pacakges with CUDA.

* Why don't we use the official build?

  * Certainly, NVIDA has its official image like `nvcr.io/nvidia/cuda:12.6.3-cudnn-devel-ubuntu24.04`. However, these images have specific OS. If you are intending to work with Ubuntu, Ubi, or RockyLinux, it is fine to use the official images. However, if you want to work with other builds like Debian, there are no available official images.

* Why don't we use the [`debian-cuda`](https://hub.docker.com/r/gw000/debian-cuda/) image?
  
  * Well, it is indeed a Debian image. However, its version is pretty old. The script used for building that image involves some Ubuntu dependencies, which is quite unrecommended.

## Pre-built images

Some pre-built images are available on DockerHub:

https://hub.docker.com/r/cainmagi/cuda

## Usage

Run the following command to build the image:

```sh
docker build -t cuda:debian-latest https://github.com/cainmagi/Dockerfiles.git#cuda
```

After that, run the following command to launch a shell

```sh
docker run --gpus all -it --rm --shm-size=1g cuda:debian-latest bash
```

> [!CAUTION]
> If you do not add <code>bash</code> at the end of the command, the container will be launched as Python.

## Supported versions

Add options to change the configurations of the building process. The option should be used like this:

```sh
docker build -t cuda:debian-latest --build-arg BASE_IMAGE=python:3.12-slim --build-arg INSTALL_OS=debian --build-arg NAME_CUDA_TOOLKIT=cuda-toolkit https://github.com/cainmagi/Dockerfiles.git#cuda
```

The options used in the above example are the default options. In other words, by using the default configurations, we will have Python 3.12, CUDA 12.6, and Debian 12.

### Debian

| Debian | CUDA  | Command                                                                                                                                                                                           |
| :----: | :---: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
|   12   | 12.6  | <pre>docker build -t cuda:debian12-cu126 --build-arg NAME_CUDA_TOOLKIT=cuda-toolkit-12-6 https://github.com/cainmagi/Dockerfiles.git#cuda</pre>                                                   |
|   12   | 12.4  | <pre>docker build -t cuda:debian12-cu124 --build-arg NAME_CUDA_TOOLKIT=cuda-toolkit-12-4 https://github.com/cainmagi/Dockerfiles.git#cuda</pre>                                                   |
|   12   | 12.3  | <pre>docker build -t cuda:debian12-cu123 --build-arg NAME_CUDA_TOOLKIT=cuda-toolkit-12-3 https://github.com/cainmagi/Dockerfiles.git#cuda</pre>                                                   |
|   11   | 12.6  | <pre>docker build -t cuda:debian11-cu126 --build-arg BASE_IMAGE=python:3.12-slim-bullseye⁠ --build-arg NAME_CUDA_TOOLKIT=cuda-toolkit-12-6 https://github.com/cainmagi/Dockerfiles.git#cuda</pre> |
|   11   | 12.4  | <pre>docker build -t cuda:debian11-cu124 --build-arg BASE_IMAGE=python:3.12-slim-bullseye --build-arg NAME_CUDA_TOOLKIT=cuda-toolkit-12-4 https://github.com/cainmagi/Dockerfiles.git#cuda</pre>  |
|   11   | 12.3  | <pre>docker build -t cuda:debian11-cu123 --build-arg BASE_IMAGE=python:3.12-slim-bullseye --build-arg NAME_CUDA_TOOLKIT=cuda-toolkit-12-3 https://github.com/cainmagi/Dockerfiles.git#cuda</pre>  |
