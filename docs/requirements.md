# Requirements to run the examples in the guide

To learn how to use CWL in the Earth Observation context, you'll need two tools:

- A CWL runner
- Docker 

## CWL runner

CWL is a set of open standards for describing computational workflows. These workflows are executed using a CWL runner and there are several implementations of such runners.

We recommend `cwltool` and the easiest way to install it is to create a conda environment with: 

```console
mamba install -n base cwltool
```

On Linux and Mac OS, test the installation with:

```console
which cwltool
```

This must return the path to the `cwltool` executable.

## Docker

For Mac and Windows 10 Pro users, install Docker Desktop following the instructions found in [https://docs.docker.com/desktop/](https://docs.docker.com/desktop/).

For Linux users, check how to do it here [https://docs.docker.com/engine/install/](https://docs.docker.com/engine/install/).

Test your installation with: 

```console
$ docker run hello-world
```

This returns:

```console
Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

```console
$ docker images hello-world
```

This outputs:

```
REPOSITORY   TAG     IMAGE ID      SIZE
hello-world  latest  d1165f221234  13336
```

## References 

- cwltool software repository: [https://github.com/common-workflow-language/cwltool](https://github.com/common-workflow-language/cwltool)
- mamba installation: [https://github.com/conda-forge/miniforge#mambaforge](https://github.com/conda-forge/miniforge#mambaforge)
- docker installation: [ttps://docs.docker.com/engine/install/](ttps://docs.docker.com/engine/install/)