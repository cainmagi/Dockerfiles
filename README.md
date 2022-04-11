# Dockerfile Collection for DGX-230

## Jupyterlab

### Online building

If you do not want to change the contents of the dockerfile, you could use such command to build the image:

```Bash
docker build -t jlab:1.4 https://github.com/cainmagi/Dockerfiles.git#jupyterlab
```

We provide 4 examples:

* Start from `pytorch 1.12.0a` image:

    ```bash
    docker build -t jlab-tc:1.4 --build-arg BASE_IMAGE=nvcr.io/nvidia/pytorch:22.03-py3 --build-arg BASE_LAUNCH=/opt/nvidia/nvidia_entrypoint.sh https://github.com/cainmagi/Dockerfiles.git#jupyterlab
    ```

* Start from `cuda 11.6` image:

    ```bash
    docker build -t jlab-cuda:1.4 --build-arg BASE_IMAGE=nvcr.io/nvidia/cuda:11.6.2-cudnn8-runtime-ubuntu20.04 --build-arg BASE_LAUNCH="" https://github.com/cainmagi/Dockerfiles.git#jupyterlab
    ```

* Start from an older `tensorflow 1.13.1` image, with Jupyter Lab fully upgraded to `2`:

    ```bash
    docker build -t jlab-tf:1.4 --build-arg BASE_IMAGE=nvcr.io/nvidia/tensorflow:19.03-py3 --build-arg BASE_LAUNCH=/usr/local/bin/nvidia_entrypoint.sh --build-arg JLAB_VER=2 --build-arg JLAB_EXTIERS=2  https://github.com/cainmagi/Dockerfiles.git#jupyterlab
    ```

* Start from `pytorch 1.12.0a`, with Jupyter Lab fully upgraded to `3`:

    ```bash
    docker build -t jlab-tc:1.4 --build-arg BASE_IMAGE=nvcr.io/nvidia/pytorch:22.03-py3 --build-arg BASE_LAUNCH=/opt/nvidia/nvidia_entrypoint.sh --build-arg JLAB_VER=3 --build-arg JLAB_EXTIERS=2 https://github.com/cainmagi/Dockerfiles.git#jupyterlab
    ```

There are 4 available options:

| Option | Description | Default |
| :-----: | ----- | ----- |
| `BASE_IMAGE` | The base image for building this desktop image. | `nvcr.io/nvidia/tensorflow:22.03-tf2-py3` |
| `BASE_LAUNCH` | The entrypoint script from the base image. If there is no entry script, please use `""`. | `/opt/nvidia/nvidia_entrypoint.sh` |
| `JLAB_VER` | The version of the Jupyter Lab to be installed. If set `1`, `2` or `3`, would fully install Jupyter Lab. If set `unset`, the Jupyter Lab would be minimally installed. It means that, no extension would be installed, and if there is already a Jupyter Lab in the base image, nothing would be installed. | `unset` |
| `JLAB_EXTIERS` | The extension tiers to be installed. Could be `1` or `2`. If `JLAB_VER=unset`, nothing would be installed. | `2` |
| `JLAB_IMODE` | The preferred manager for installing Jupyter Lab. If set `conda`, it will use `conda` when `conda` is available. If not, would fall back to `pip`. | `conda` |
| `ADDR_PROXY` | Set the proxy address pointing to `localhost`. If specified, this value should be a full address. | `unset` |
| `SKIP_PIP` | If specified as `true`, will skip the reinstallation of `python-pip`. | `false` |

> Note:
>
> Previously, the `BASE_LAUNCH` value should be `/usr/local/bin/nvidia_entrypoint.sh` for using those old images. However, this value changes if using new NVIDIA images as the base images.

> Note:
>
> Currently, the Jupyter Lab 3 is still under development. However, we think it is good enough for serving as the suggested option now. It means, using `--build-arg JLAB_VER=3 --build-arg JLAB_EXTIERS=2`.
> However, if you are using a base image with `python<=3.5`, we suggest that the option should fall back to Jupyter Lab 2.

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
docker build -t jlab:1.4 jupyterlab
```

where `jupyterlab` is the folder of the corresponding branch. The options in online building examples could be also used for offline buliding.

### Launching

* By `Jupyter Lab`: If you want to launch the Jupyter Lab but do not start the desktop, please use

    ```bash
    docker run --gpus all -it --rm -v ~:/homelocal -p 6080:6080 jlab:1.4 password=openjupyter rootdir=/homelocal
    ```

    The `password` would override the default random token. The `rootdir` is the root folder of the launched jupyter lab. If not set `rootdir`, the default root folder would be `/homelocal`.

    It is equivalent to use `--jlab` or not in the above command. However, if you have saved the image in other modes before, you may need this flag to force the image to enter the Jupyter Lab mode.

* By `BASH`: If you want to enter the command line but do not start the desktop, please use

    ```bash
    docker run --gpus all -it --rm -v ~:/homelocal jlab:1.4 --bash
    ```

* By any script: If you want run any script inside the docker for only one time, please use

    ```bash
    docker run --gpus all -it --rm -v ~:/homelocal jlab:1.4 script=<the-path-to-your-script>
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
| [`jupyterlab-variableinspector`](https://github.com/lckr/jupyterlab-variableInspector)           | | | :ballot_box_with_check: |
| [`ipylab`](https://github.com/jtpio/ipylab)                                                      | | | :ballot_box_with_check: |
| [`jupyterlab-language-pack-zhCN`](https://github.com/jupyterlab/language-packs)                  | | | :white_check_mark: |
| [`jupyterlab-toc`](https://github.com/jupyterlab/jupyterlab-toc)                                 | | :white_check_mark: | :ballot_box_with_check: |
| [`jupyterlab-lsp`](https://github.com/krassowski/jupyterlab-lsp)                                 | | :white_check_mark: | :ballot_box_with_check: |
| [`jupyterlab-debugger`](https://github.com/jupyterlab/debugger)                                  | | :white_check_mark: | :ballot_box_with_check: |
| [`xpython`](https://github.com/jupyter-xeus/xeus-python)                                         | | :white_check_mark: | :white_check_mark: |
| [`jupyterlab_go_to_definition`](https://github.com/krassowski/jupyterlab-go-to-definition)       | :white_check_mark: | :white_check_mark: | |
| [`jupyterlab-google-drive`](https://github.com/jupyterlab/jupyterlab-google-drive)               | :white_check_mark: | :white_check_mark: | |
| [`jupyterlab-hdf5`](https://github.com/jupyterlab/jupyterlab-hdf5)                               | :ballot_box_with_check: | :ballot_box_with_check: | :ballot_box_with_check:
| [`jupyterlab-nvdashboard`](https://github.com/rapidsai/jupyterlab-nvdashboard) :small_blue_diamond: | :ballot_box_with_check: | :ballot_box_with_check: | :ballot_box_with_check: |
| [`jupyterlab-github`](https://github.com/jupyterlab/jupyterlab-github)                           | :white_check_mark: | :white_check_mark: | :ballot_box_with_check: |
| [`jupyterlab-git`](https://github.com/jupyterlab/jupyterlab-git)                                 | :white_check_mark: | :white_check_mark: | :ballot_box_with_check: |
| [`jupyter-bokeh`](https://github.com/bokeh/jupyter_bokeh)                                        | :white_check_mark: | :white_check_mark: | :ballot_box_with_check: |
| [`jupyterlab-jupytext`](https://github.com/mwouts/jupytext/tree/master/packages/labextension)    | :white_check_mark: | :white_check_mark: | :ballot_box_with_check: |
| [`jupyterlab-system-monitor`](https://github.com/jtpio/jupyterlab-system-monitor)                | :white_check_mark: | :white_check_mark: | :ballot_box_with_check: |
| [`jupyterlab-topbar`](https://github.com/jtpio/jupyterlab-topbar)                                | :white_check_mark: | :white_check_mark: | :ballot_box_with_check: |
| [`jupyterlab-sidecar`](https://github.com/jupyter-widgets/jupyterlab-sidecar)                    | :white_check_mark: | :white_check_mark: | :ballot_box_with_check: |
| [`jupyterlab-katex-extension`](https://github.com/jupyterlab/jupyter-renderers/blob/master/packages/katex-extension) | :white_check_mark: | :white_check_mark: | :ballot_box_with_check: |
| [`jupyterlab-mathjax3-extension`](https://github.com/jupyterlab/jupyter-renderers/blob/master/packages/mathjax3-extension) | :white_check_mark: | :white_check_mark: | :ballot_box_with_check: |
| [`jupyterlab-matplotlib`](https://github.com/matplotlib/jupyter-matplotlib.git)                  | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| [`jupyterlab-nbdime`](https://github.com/jupyter/nbdime)                                         | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| [`jupyterlab-manager`](https://github.com/jupyter-widgets/ipywidgets)                            | :white_check_mark: | :white_check_mark: | :white_check_mark: |

1. :small_blue_diamond: if installed with J-lab3, `jupyterlab_nvdashboard` only works with `python>=3.7`.

### Tier 2

To install the following extensions, use the building argument `JLAB_EXTRA_TIERS=2`.

| Extension | J-lab1 | J-lab2 | J-lab3 |
| ----- | :-----: | :-----: | :-----: |
| [`jupyterlab-drawio`](https://github.com/QuantStack/jupyterlab-drawio)                        | | | :ballot_box_with_check: |
| [`ipydagred3`](https://github.com/timkpaine/ipydagred3)                                       | | | :ballot_box_with_check: |
| [`jupyterlab_html`](https://github.com/mflevine/jupyterlab_html)                              | :white_check_mark: | | |
| [`jupyterlab-code-formatter`](https://github.com/ryantam626/jupyterlab_code_formatter)        | :ballot_box_with_check: | :ballot_box_with_check: | :ballot_box_with_check: |
| [`jupyterlab_iframe`](https://github.com/timkpaine/jupyterlab_iframe) :small_blue_diamond:    | :ballot_box_with_check: | :ballot_box_with_check: | :ballot_box_with_check: |
| [`jupyterlab-tensorboard`](https://github.com/chaoleili/jupyterlab_tensorboard)               | :white_check_mark: | :white_check_mark: | :ballot_box_with_check: |
| [`jupyterlab-dash`](https://github.com/plotly/jupyterlab-dash)                                | :white_check_mark: | :white_check_mark: | :ballot_box_with_check: |
| [`pyviz-comms`](https://github.com/holoviz/pyviz_comms)                                       | :white_check_mark: | :white_check_mark: | :ballot_box_with_check: |
| [`ipydatawidgets`](https://github.com/vidartf/ipydatawidgets)                                 | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| [`jupyterlab-plotly`](https://github.com/plotly/plotly.py)                                    | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| [`bqplot`](https://github.com/bqplot/bqplot)                                                  | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| [`ipycanvas`](https://github.com/martinRenou/ipycanvas)                                       | :white_check_mark: | :white_check_mark: | :white_check_mark: |

1. :small_blue_diamond: `jupyterlab_iframe` only works with `python>=3.7`

## Test report

> Note:
>
> We use :white_check_mark: to represent the image is fully built. In comparison, :ballot_box_with_check: means the image requires to be built in compatible mode.

### 4/10/2022

We upgrade the `conda` script with a faster package manager [`mamba` :link:][git-mamba]. The new manager `mamba` will replace `conda` in the whole workflow. Currently the `conda` script only supports `python>=3.6`.

| Base image | J-lab1 | J-lab2 | J-lab3 |
| ----- | :-----: | :-----: | :-----: |
| `nvcr.io/nvidia/pytorch:19.01-py3` (`conda`) | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| `nvcr.io/nvidia/tensorflow:19.03-py3` (`pip`) | :ballot_box_with_check: | :ballot_box_with_check: | :ballot_box_with_check: |
| `nvcr.io/nvidia/pytorch:22.03-py3` (`conda`) | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| `nvcr.io/nvidia/tensorflow:22.03-tf2-py3` (`pip`) | :white_check_mark: | :white_check_mark: | :white_check_mark: |

> Althogh those deprecated options still work with `Jupyterlab 3.3.3`, they are replaced by new option standards in the launching script of the `1.4` image.

### 6/20/2021

The `conda` script for installing jupyter lab has been finished. The script would be used only if the conda is detected. Currently the `conda` script only supports `python>=3.6`.

| Base image | J-lab1 | J-lab2 | J-lab3 |
| ----- | :-----: | :-----: | :-----: |
| `nvcr.io/nvidia/pytorch:19.01-py3` (`conda`) | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| `nvcr.io/nvidia/tensorflow:19.03-py3` (`pip`) | :ballot_box_with_check: | :ballot_box_with_check: | :ballot_box_with_check: |
| `nvcr.io/nvidia/pytorch:21.05-py3` (`conda`) | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| `nvcr.io/nvidia/tensorflow:21.05-tf2-py3` (`pip`) | :white_check_mark: | :white_check_mark: | :white_check_mark: |

> The deprecated options still work with `Jupyterlab 3.1.0a11`. We do not need to change the option list now.

### 1/30/2021

The `conda` script for installing jupyter lab has been finished. This script only supports `python>=3.6` and would not check or install `conda`. We have tested it on the following images:

| Base image | J-lab1 | J-lab2 | J-lab3 |
| ----- | :-----: | :-----: | :-----: |
| `nvcr.io/nvidia/pytorch:19.01-py3` | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| `nvcr.io/nvidia/pytorch:20.12-py3` | :white_check_mark: | :white_check_mark: | :white_check_mark: |

> We have noticed that some options' names are changed since Jupyter Lab 3. Now they are just deprecated, but still could work. In the next version of this dockerfile, we will provide a script for checking the version of Jupyter Lab and enable the entrypoint to use different start options.

### 1/29/2021

We have finished the upgrade for pip based installation script today. Most of the useful extensions are added in this version. Here we show a list of available extensions for the newest Jupyter Lab 3. If anyone feel interested, please keep track on this issue:

https://github.com/jupyterlab/jupyterlab/issues/9461

In this update, the new packages are mostly picked from the above link.

| Base image | J-lab1 | J-lab2 | J-lab3 |
| ----- | :-----: | :-----: | :-----: |
| `nvcr.io/nvidia/tensorflow:19.03-py3` | :ballot_box_with_check: | :ballot_box_with_check: | :ballot_box_with_check: |
| `nvcr.io/nvidia/pytorch:19.01-py3` | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| `nvcr.io/nvidia/pytorch:20.12-py3` | :white_check_mark: | :white_check_mark: | :white_check_mark: |

### 1/24/2021

In 1/23/2021, `pip 21.0` has been released. Since this version, `python<=3.5` would not be supported. To solve this problem, see the following issue:

https://github.com/pypa/pip/issues/9500

After fixing this problem for compatibility, I perform the following tests and ensure that all tests get passed.

| Base image | J-lab1 | J-lab2 | J-lab3 |
| ----- | :-----: | :-----: | :-----: |
| `nvcr.io/nvidia/tensorflow:19.03-py3` | :ballot_box_with_check: | :ballot_box_with_check: | :ballot_box_with_check: |
| `nvcr.io/nvidia/pytorch:19.01-py3` | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| `nvcr.io/nvidia/pytorch:20.12-py3` | :white_check_mark: | :white_check_mark: | :white_check_mark: |

### 1/16/2021

The following tests has been passed.

| Base image | J-lab1 | J-lab2 | J-lab3 |
| ----- | :-----: | :-----: | :-----: |
| `nvcr.io/nvidia/tensorflow:19.03-py3` | :ballot_box_with_check: | :ballot_box_with_check: | :ballot_box_with_check: |
| `nvcr.io/nvidia/pytorch:19.01-py3` | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| `nvcr.io/nvidia/pytorch:20.11-py3` | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| `nvcr.io/nvidia/tensorflow:20.12-tf2-py3` | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| `nvcr.io/nvidia/pytorch:20.12-py3` | :white_check_mark: | :white_check_mark: | :white_check_mark: |

## Update records

### ver 1.4 @ 4/10/2022

1. Bump the J-lab versions to `1.12.21`, `2.3.2` and `2.2.9` respectively. (When using `python<=3.6`, J-lab 2 has to be downgraded to `2.2.9` for compatibility issues.)
2. Drop the support of [`@aquirdturtle/collapsible_headings` :link:](https://github.com/aquirdTurtle/Collapsible_Headings). It is not working with J-lab `3.3.3` now.
3. Confirm that [`jupyterlab-hdf5` :link:](https://github.com/jupyterlab/jupyterlab-hdf5) and [`jupyterlab-github` :link:](https://github.com/jupyterlab/jupyterlab-github) is compatible with J-lab 3 now.
4. Add [`jupyterlab-code-formatter` :link:](https://github.com/ryantam626/jupyterlab_code_formatter), [`jupyterlab_iframe` :link:](https://github.com/timkpaine/jupyterlab_iframe), and [`ipydatawidgets` :link:](https://github.com/vidartf/ipydatawidgets) to [Tier 2](#tier-2).
5. Fix the incorrectness of the installtion for some not working plugins like [`ipycanvas` :link:](https://github.com/martinRenou/ipycanvas).
6. Use a third-party source to make [`jupyterlab-tensorboard` :link:](https://github.com/chaoleili/jupyterlab_tensorboard) work with J-lab 3.
7. Upgrade the `conda` script with a faster package manager [`mamba` :link:][git-mamba]. This modification significantly improve the efficiency of the `conda` script.
8. Prefer the `conda` script for updating the python packages when updating python.
9. Fix some bugs caused by missing of `libffi`, `libssl`, and `rustc`+`cargo`.
10. Bump the default base image and the base script location to new versions.

### ver 1.3 @ 6/19/2021

1. Support the proxy value for the built image, this value is important for the devices protected by the firewall.
2. Support more extensions: `ipycanvas`.
3. Bump the extensions to the newest versions for supporting Jupyter Lab 3: `jupyterlab-git`, `jupyterlab-nvdashboard`, `jupyter-bokeh`.
4. Fix a bug caused by the changed address of `get-pip.py`.
5. Fix the compatibility issues caused by `jupyterlab-nvdashboard` and `bqplot`.

### ver 1.2 @ 1/30/2021

1. Make python version auto-detected, which means `JLAB_COMPAT` has been removed.
2. Support more useful extensions: `nbdime`, `lsp`, `git`, `mathjax&katex`, `debugger`, `xpython`, `bokeh`, `google-drive`, `sidecar`, `drawio`,  `ipydagred3`, `pyviz`, `bqplot`.
3. Provide a installation script for `conda`. This script would only work without compatible mode. If `python<=3.5`, the installation module would fall back to `pip`.
4. Make the python version pinned (fixed) when using `conda` script.
5. Fix some bugs in `install-jlab`.

### ver 1.1 @ 1/24/2021

1. Fix the bug caused by the incompatibility of `pip-21`.
2. Fix the bug caused by `tensorboard` requirement.
3. Fix the bug caused by `tornado>=6` when `jupyterlab<=2`.
4. Fix a bug of `run_with_nodejs` in installation script and entry script.
5. Fix a bug of installing `jupyterlab-system-monitor`.

### ver 1.1 @ 1/15/2021

1. Update the `Jupyter Lab` installation script, now it supports 3 different version.
2. Update the `Jupyter Lab` extension installation script.
3. Add compatible mode for `python<=3.5`.
4. Fix some bugs for installing python3.
5. Add some packages for basic installation.
6. Add features to the entrypoint script.

### ver 1.0 @ 12/18/2020

Create the dockerfile branch.

[git-mamba]:https://github.com/mamba-org/mamba
