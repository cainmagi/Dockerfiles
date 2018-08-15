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

    Download the file and run such command to build the image:
    
    ```Bash
    $ nvidia-docker build -t xubuntu:1.0 xubuntu
    ```
    
    where `xubuntu` is the folder of the corresponding branch.
   
2. xubuntu-tf at the branch  [**xubuntu-tf**](https://github.com/cainmagi/Dockerfiles/tree/xubuntu-tf)

    Download the branch and run such command to build the image:

    ```Bash
    $ nvidia-docker build -t xubuntu-tf:1.0 xubuntu-tf
    ```

    where `xubuntu-tf` is the folder of the corresponding branch.
   
## Update records

### ver 1.1 @ 20180815

Add the `xubuntu-tf` dockerfile.

### ver 1.0 @ 20180605

Create the branch, add the noVNC submodule and add the `xubuntu` dockerfile.
