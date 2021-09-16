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
sudo mv bin/micromamba /usr/local/bin/micromamba
sudo chmod +x /usr/local/bin/micromamba
```

Initialize the shell:

```console
micromamba shell init -s bash -p ~/micromamba
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

### Test the CWL runner installation with:

```console
cwltool --help
```

This must return the path to the `cwltool` executable.

## Docker

### Linux

For Linux users, check how to install docker here: https://docs.docker.com/engine/install/#server.

### Mac OS X

Install Docker Desktop following the instructions found in https://docs.docker.com/desktop/mac/install/.

### Windows 10 Pro

Install Docker Desktop following the instructions found in https://docs.docker.com/desktop/windows/install/.

### Testing your docker installation

Test your installation in a terminal with: 

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