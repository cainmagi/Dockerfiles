# Dockerfile Collection for DGX-230

## Jupyterlab

### Online building

If you do not want to change the contents of the dockerfile, you could use such command to build the image:

```Bash
$ nvidia-docker build -t jupyterlab:1.0 https://github.com/cainmagi/Dockerfiles.git#jupyterlab
```

### Offline building

Otherwise, you need to clone the branch firsly:

```Bash
$ git clone --single-branch -b jupyterlab https://github.com/cainmagi/Dockerfiles.git jupyterlab
```

After that, run such command to build the image:

```Bash
$ nvidia-docker build -t jupyterlab:1.0 jupyterlab
```

where `jupyterlab` is the folder of the corresponding branch.

## Features

This is the minimal desktop test based on an arbitrary image, it has:

## Update records

### ver 1.0 @ 12/18/2020

Create the dockerfile branch.
