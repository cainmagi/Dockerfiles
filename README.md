# Dockerfiles

A collection of my personal customized Dockerfiles.

## TeXLive with Code

This image contains the following software:

* TeXLive
* Code Server (accessed by browser)
* Extensions used for working with LaTeX projects
* Git and GitHub supports

Code Server is the browser version of the VSCode. To learn the details, see

https://github.com/coder/code-server/tree/main

> [!NOTE]
> Note that this Code Server is a third-party implementation which is fully licensed by MIT License.
Although Microsoft VSCode **does not allows hosted as a service**, see [here](https://code.visualstudio.com/license/server), this third-part Code Server is specially designed for self-hosting.
>
> Therefore, this project is also licensed by MIT License. The VSCode License is not referred by this project.

> [!CAUTION]
> The build option `EXT_SOURCE` allows users to access the Microsoft Market to get the extensions. This option is designed for building the image when [open-vsx](https://open-vsx.org) is down. However, if you use the Microsoft Market, the license of the built image may be broken. **Do not use the image for commercial purposes or host the image in the public domain if you are using market extensions**.

## Pre-built images

Some pre-built images are available on DockerHub:

https://hub.docker.com/r/cainmagi/texlive-code

## Usage

Run the following command to build the image:

```sh
docker pull cainmagi/texlive-code:2025
```

After that, run the following command to launch the service

```sh
docker run --gpus all -it --rm --shm-size=1g -p 8000:8000 cainmagi/texlive-code:2025
```

When launching the newly built container for the first time, it will ask for configuring some passwords.
After that, you can access the online editor by

```txt
http://localhost:8000
```

The following video shows an example of how to use the editor with GitHub repositories.



## Extra usages

### Rebase the file access authority

By default, the image user has an USER-ID of 1000. If you want to reconfigure the whole file and make the image rebase to another user, use

```sh
docker run --gpus all -it --rm --shm-size=1g -p 8000:8000 cainmagi/texlive-code:2025 uid=$(id -u) gid=$(id -g)
```

> [!NOTE]
> This situation only exists for Linux users. If you are using Windows and Docker Desktop, you do not need to concern such issues.

### Reconfigure Code Server

If you do not want to switch the code server but only want to reconfigure the code server, use

```sh
docker run --gpus all -it --rm --shm-size=1g -p 8000:8000 cainmagi/texlive-code:2025 --reconfig
```

### Enter the bash

The following command will launch the bash.

```sh
docker run --gpus all -it --rm --shm-size=1g -p 8000:8000 cainmagi/texlive-code:2025 --bash
```

### Help and Version

Using the following commands to display the help message and the version message of `code-server`.

```sh
docker run --gpus all -it --rm --shm-size=1g -p 8000:8000 cainmagi/texlive-code:2025 --help
docker run --gpus all -it --rm --shm-size=1g -p 8000:8000 cainmagi/texlive-code:2025 --verison
```

### Pass extra configurations

Any configurations of `code-server`, except `--config`, can be passed to `docker run`. For example, you can override the name of the application shown in the welcome page.

```sh
docker run --gpus all -it --rm --shm-size=1g -p 8000:8000 cainmagi/texlive-code:2025 --app-name AnyName
```

## Build the image

```sh
docker build -t cainmagi/texlive-code:2025 https://github.com/cainmagi/Dockerfiles.git#texlive
```

Adding arguments by `--build-arg OPTION=...` is allowed. The options are list as below

|     Option     | <center>Default</center>              | <center>Description</center>                                                                                                                                                     |
| :------------: | :------------------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|  `BASE_IMAGE`  | `texlive/texlive:latest-full-doc-src` | The base image should contain a TeXLive release. We suggest that this option should not be changed.                                                                              |
| `INSTALL_MODE` | `default`                             | The installation mode can be changed to `dev`, `dev1`, or `dev2` which will install more dependencies.                                                                           |
|  `INSTALL_OS`  | `debian`                              | Currently, we only support `debian`.                                                                                                                                             |
|     `LANG`     | `en_US.UTF-8`                         | The language of the program. Currently, we suppose to support `en_US.UTF-8` and `zh_CN.UTF-8`. However, when `open-vsx` is down, we do not recommend to build a `zh_CN` version. |
|  `EXT_SOURCE`  | `default`                             | Can be `auto` or `market`. If changing this option, it may access the Microsoft Market for installing the extensions, which may cause the MIT License broken.                    |

## Supported versions

We will update the image according to the update of `TeXLive`. Check the following information to view the versions of the pre-built images.

| Debian | TeXLive | Code Server | <center>Image Name</center>   | <center>Command</center>                                                                                  |
| :----: | :-----: | :---------: | :---------------------------- | :-------------------------------------------------------------------------------------------------------- |
|   13   |  2025   |   4.99.3    | `cainmagi/textlive-code:2025` | <pre>docker build -t cainmagi/texlive-code:2025 https://github.com/cainmagi/Dockerfiles.git#texlive</pre> |
