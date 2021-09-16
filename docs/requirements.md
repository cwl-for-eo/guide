# Requirements to run the examples in the guide

To learn how to use CWL in the Earth Observation context, you'll need two tools:

- A CWL runner
- Docker 

## CWL runner

CWL is a set of open standards for describing computational workflows. These workflows are executed using a CWL runner and there are several implementations of such runners.

We recommend `cwltool` and one of the easiest way to install it is to use `micromamba` and install `cwltool` in the `base` environment.

### Linux

Install `micromamba`

```console
wget -qO- https://micromamba.snakepit.net/api/micromamba/linux-64/latest | tar -xvj bin/micromamba --strip-components=1
``` 

Initialize the shell:

```console
./micromamba shell init -s bash -p ~/micromamba
source ~/.bashrc
```

Install cwltool

```console
micromamba activate
micromamba install -c conda-forge cwltool
```

Test the installation with:

```console
which cwltool
```

This must return the path to the `cwltool` executable.

### MacOS X

Install `micromamba`:

```console
curl -Ls https://micromamba.snakepit.net/api/micromamba/osx-64/latest | tar -xvj bin/micromamba
sudo mv bin/micromamba /usr/local/bin/micromamba
sudo chmod +x /usr/local/bin/micromamba
```

Initialize the shell with:

```console
micromamba shell init -s zsh -p ~/micromamba
source ~/.zshrc
```

Activate `micromamba` and install `cwltool` in the _base_ environment:

```console
micromamba activate
micromamba install -c conda-forge cwltool
```

### Windows

TBW.

Test the installation with:

```console
which cwltool
```

This must return the path to the `cwltool` executable.

## Docker

For Linux users, check how to do it here [https://docs.docker.com/engine/install/](https://docs.docker.com/engine/install/).

For Mac and Windows 10 Pro users, install Docker Desktop following the instructions found in [https://docs.docker.com/desktop/](https://docs.docker.com/desktop/).

Test your installation with: 

```console
$ docker run hello-world
```

After the container image pull, this returns:

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
- docker installation: [https://docs.docker.com/engine/install/](ttps://docs.docker.com/engine/install/)