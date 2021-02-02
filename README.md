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
noVNC IP=192.168.127.128:5901 PORT=6080
```

where `5901` is the entry (input) port and `6080` is the service (output) port.

## Dockerfiles

Here is the list of each dockerfile:

1. xubuntu at the branch [**xubuntu**](https://github.com/cainmagi/Dockerfiles/tree/xubuntu)

    Run such a command to build the newest image online:

    ```Bash
    nvidia-docker build -t xubuntu:1.0 https://github.com/cainmagi/Dockerfiles.git#xubuntu
    ```

2. jupyterlab at the branch  [**jupyterlab**](https://github.com/cainmagi/Dockerfiles/tree/jupyterlab)

    Run such a command to build the newest image online:

    ```Bash
    nvidia-docker build -t jlab:1.0 https://github.com/cainmagi/Dockerfiles.git#jupyterlab
    ```

## Update records

See the update records in [docs-DGX branch](https://github.com/cainmagi/Dockerfiles/blob/docs-DGX/index.md#update-records).
