# Dockerfile Collection for DGX-230

## Jupyterlab

### Online building

If you do not want to change the contents of the dockerfile, you could use such command to build the image:

```Bash
docker build -t jlab:1.0 https://github.com/cainmagi/Dockerfiles.git#jupyterlab
```

We provide 3 examples:

* Start from `pytorch 1.8.0a` image:

    ```bash
    docker build -t jlab-tc:1.0 --build-arg BASE_IMAGE=nvcr.io/nvidia/pytorch:20.12-py3 --build-arg BASE_LAUNCH=/usr/local/bin/nvidia_entrypoint.sh https://github.com/cainmagi/Dockerfiles.git#jupyterlab
    ```

* Start from `cuda 11.1` image:

    ```bash
    docker build -t jlab-cuda:1.0 --build-arg BASE_IMAGE=nvcr.io/nvidia/cuda:11.1-cudnn8-runtime-ubuntu20.04 --build-arg BASE_LAUNCH="" https://github.com/cainmagi/Dockerfiles.git#jupyterlab
    ```

* Start from `pytorch 1.8.0a`, with Jupyter Lab fully upgraded to `2`:

    ```bash
    docker build -t jlab-tc:1.0 --build-arg BASE_IMAGE=nvcr.io/nvidia/pytorch:20.12-py3 --build-arg BASE_LAUNCH=/usr/local/bin/nvidia_entrypoint.sh --build-arg JLAB_VER=2 --build-arg JLAB_EXTIERS=2 https://github.com/cainmagi/Dockerfiles.git#jupyterlab
    ```

There are 4 available options:

| Option | Description | Default |
| :-----: | ----- | ----- |
| `BASE_IMAGE` | The base image for building this desktop image. | `nvcr.io/nvidia/tensorflow:19.04-py3` |
| `BASE_LAUNCH` | The entrypoint script from the base image. If there is no entry script, please use `""`. | `/usr/local/bin/nvidia_entrypoint.sh` |
| `JLAB_VER` | The version of the Jupyter Lab to be installed. If set `1`, `2` or `3`, would fully install Jupyter Lab. If set `unset`, the Jupyter Lab would be minimally installed. It means that, no extension would be installed, and if there is already a Jupyter Lab in the base image, nothing would be installed. | `unset` |
| `JLAB_EXTIERS` | The extension tiers to be installed. Could be `1` or `2`. If `JLAB_VER=unset`, nothing would be installed. | `2` |
| `JLAB_COMPAT` | Compatible mode for building the image. When your base image has a `python<=3.5`, please use this mode. | `false` |

> Note:
>
> Currently, the Jupyter Lab 3 is still under development. Since it is not stable enough now, we suggest to install Jupyter Lab 2. It means, using `--build-arg JLAB_VER=2 --build-arg JLAB_EXTIERS=2`.
> Although I have tried to managed some special cases, the installation script may still meet problems if your python is maintained by conda. In the future, I will try to develop the conda version if we need it.

> Note
>
> Currently, the dockerfile only supports the base images with `Ubuntu` `16.04`, `18.04` and  `20.04`.

To find your launch script of your base image, use

```bash
docker inspect <your-base-image>:<tag>
```

### Offline building

Otherwise, you need to clone the branch firsly:

```Bash
git clone --single-branch -b jupyterlab https://github.com/cainmagi/Dockerfiles.git jupyterlab
```

After that, run such command to build the image:

```Bash
docker build -t jlab:1.0 jupyterlab
```

where `jupyterlab` is the folder of the corresponding branch. The options in online building examples could be also used for offline buliding.

### Launching

* By `Jupyter Lab`: If you want to launch the Jupyter Lab but do not start the desktop, please use

    ```bash
    docker run --gpus all -it --rm -v ~:/homelocal -p 6080:6080 jlab:1.0 password=openjupyter rootdir=/homelocal
    ```

    The `password` would override the default random token. The `rootdir` is the root folder of the launched jupyter lab. If not set `rootdir`, the default root folder would be `/homelocal`.

    It is equivalent to use `--jlab` or not in the above command. However, if you have saved the image in other modes before, you may need this flag to force the image to enter the Jupyter Lab mode.

* By `BASH`: If you want to enter the command line but do not start the desktop, please use

    ```bash
    docker run --gpus all -it --rm -v ~:/homelocal jlab:1.0 --bash
    ```

* By any script: If you want run any script inside the docker for only one time, please use

    ```bash
    docker run --gpus all -it --rm -v ~:/homelocal jlab:1.0 script=<the-path-to-your-script>
    ```

## Features

This image will install `Jupyter Lab` and its several useful extensions. Different extensions require the support of different Jupyter Lab version. Currently, the Jupyter Lab 3 is still under development. Since it is not stable enough now, we suggest to install Jupyter Lab 2. The available extension list is shown as below:

> Note
>
> In the following lists, we use the following symbols to represent:
>
> * :white_check_mark:: the package is available for the specific Jupyter Lab version.
> * :ballot_box_with_check:: the package is available, but not working with `python<=3.5`. If using the compatible mode, it would not be installed.

### Tier 1

To install the following extensions, use the building argument `JLAB_EXTRA_TIERS=1` or `JLAB_EXTRA_TIERS=2`.

| Extension | J-lab1 | J-lab2 | J-lab3 |
| ----- | :-----: | :-----: | :-----: |
| [`jupyterlab-language-pack-zhCN`](https://github.com/jupyterlab/language-packs)                  | | | :white_check_mark: |
| [`jupyterlab-nbdime`](https://github.com/jupyter/nbdime)                                         | | | :white_check_mark: |
| [`@aquirdturtle/collapsible_headings`](https://github.com/aquirdTurtle/Collapsible_Headings)     | | | :ballot_box_with_check: |
| [`jupyterlab-lsp`](https://github.com/krassowski/jupyterlab-lsp)                                 | | | :ballot_box_with_check: |
| [`jupyterlab-variableinspector`](https://github.com/lckr/jupyterlab-variableInspector)           | | | :ballot_box_with_check: |
| [`jupyterlab-jupytext`](https://github.com/mwouts/jupytext/tree/master/packages/labextension)    | | :white_check_mark: | :ballot_box_with_check: |
| [`jupyterlab-toc`](https://github.com/jupyterlab/jupyterlab-toc)                                 | | :white_check_mark: | :ballot_box_with_check: |
| [`jupyterlab-hdf5`](https://github.com/jupyterlab/jupyterlab-hdf5)                               | :ballot_box_with_check: | :ballot_box_with_check: | |
| [`jupyterlab-github`](https://github.com/jupyterlab/jupyterlab-github)                           | :white_check_mark: | :white_check_mark: | |
| [`jupyterlab-nvdashboard`](https://github.com/rapidsai/jupyterlab-nvdashboard)                   | :ballot_box_with_check: | :ballot_box_with_check: | |
| [`jupyterlab_go_to_definition`](https://github.com/krassowski/jupyterlab-go-to-definition)       | :white_check_mark: | :white_check_mark: | |
| [`jupyterlab-matplotlib`](https://github.com/matplotlib/jupyter-matplotlib.git)                  | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| [`jupyterlab-manager`](https://github.com/jupyter-widgets/ipywidgets) | :white_check_mark:       | :white_check_mark: | :white_check_mark: |
| [`jupyterlab-system-monitor`](https://github.com/jtpio/jupyterlab-system-monitor)                | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| [`jupyterlab-topbar`](https://github.com/jtpio/jupyterlab-topbar)                                | :white_check_mark: | :white_check_mark: | :white_check_mark: |

### Tier 2

To install the following extensions, use the building argument `JLAB_EXTRA_TIERS=2`.

| Extension | J-lab1 | J-lab2 | J-lab3 |
| ----- | :-----: | :-----: | :-----: |
| [`jupyterlab-tensorboard`](https://github.com/chaoleili/jupyterlab_tensorboard) | :white_check_mark: | :white_check_mark: | |
| [`jupyterlab-dash`](https://github.com/plotly/jupyterlab-dash)                  | :white_check_mark: | :white_check_mark: | |
| [`jupyterlab_html`](https://github.com/mflevine/jupyterlab_html)                | :white_check_mark: | | |
| [`jupyterlab-plotly`](https://github.com/plotly/plotly.py)                      | :white_check_mark: | :white_check_mark: | :white_check_mark: |

## Test report

### 1/16/2021

The following tests has been passed.

> Note:
>
> We use :white_check_mark: to represent the image is fully built. In comparison, :ballot_box_with_check: means the image requires to be built in compatible mode.

| Base image | J-lab1 | J-lab2 | J-lab3 |
| ----- | :-----: | :-----: | :-----: |
| `nvcr.io/nvidia/tensorflow:19.03-py3` | :ballot_box_with_check: | :ballot_box_with_check: | :ballot_box_with_check: |
| `nvcr.io/nvidia/pytorch:19.01-py3` | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| `nvcr.io/nvidia/pytorch:20.11-py3` | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| `nvcr.io/nvidia/tensorflow:20.12-tf2-py3` | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| `nvcr.io/nvidia/pytorch:20.12-py3` | :white_check_mark: | :white_check_mark: | :white_check_mark: |

## Update records

### ver 1.1 @ 1/15/2021

1. Update the `Jupyter Lab` installation script, now it supports 3 different version.
2. Update the `Jupyter Lab` extension installation script.
3. Add compatible mode for `python<=3.5`.
4. Fix some bugs for installing python3.
5. Add some packages for basic installation.
6. Add features to the entrypoint script.

### ver 1.0 @ 12/18/2020

Create the dockerfile branch.
