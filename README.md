# Dockerfile Collection for DGX-230

## Master branch

Here we provide a submodule `noVNCbin` cloned from 

[https://github.com/novnc/noVNC](https://github.com/novnc/noVNC)

and we also provide a wrapping script `noVNC` which calls the `noVNCbin` scripts here.

To make use of this service, just copy this branch to your `/usr/local/bin/` like

```Bash
/usr/local/bin/
|---noVNC
`---noVNCbin
    |---utils
    |   |---launch.sh
    |   `---...
    `---...
```

And you could use such simple command on your Bash:

```Bash
$ noVNC IP=172.17.0.2:5901 PORT=6080
```

where `5901` is the entry (input) port and `6080` is the service (output) port.

## Dockerfiles

Here is the list of each dockerfile:

1. xubuntu at the branch [**xubuntu**](https://github.com/cainmagi/Dockerfiles/tree/xubuntu)

    Run such a command to build the newest image online:
    
    ```Bash
    $ nvidia-docker build -t xubuntu:1.12 https://github.com/cainmagi/Dockerfiles.git#xubuntu
    ```
   
2. xubuntu-tf at the branch  [**xubuntu-tf**](https://github.com/cainmagi/Dockerfiles/tree/xubuntu-tf)

    Run such a command to build the newest image online:

    ```Bash
    $ nvidia-docker build -t xubuntu-tf:1.2 https://github.com/cainmagi/Dockerfiles.git#xubuntu-tf
    ```
   
## Update records

### ver 1.16 @ 20180820

Update xubuntu-tf to 1.2 version.

### ver 1.15 @ 20180819

1. Revise the `xubuntu-tf` dockerfile for fixing some bugs in the installation scripts.
2. Revise the `xubuntu` dockerfile, upgrade its dependencies and make a good preparation for installing caffe with gcc-6.3.0 in this image.

### ver 1.12 @ 20180816

1. Revise the `xubuntu-tf` dockerfile and upgrade its dependencies.
2. Revise `noVNC`, now we do not need to change anything but just copy it for the installation.
3. Arrange the page of this project.

### ver 1.1 @ 20180815

Add the `xubuntu-tf` dockerfile.

### ver 1.0 @ 20180605

Create the branch, add the noVNC submodule and add the `xubuntu` dockerfile.
