# The Common Workflow Language for Earth Observation Guide

## TL;DR

This is a guide with best practices and examples to adopt CWL in Earth Observation workflows

## Contributing

### Contribute to the guide repository

Clone and checkout the repository and its git submodules

Build the mkdocs container image with:

```console
docker build -f Dockerfile -t docs-dev .
```

Build and expose the docs:

```console
docker run --rm -it -p 8000:8000 -v ${PWD}:/docs docs-dev:latest
```

Open your browser at [http://0.0.0.0:8000](http://0.0.0.0:8000)

Add your contributions.

Push the changes to the repository

### Contribute to a submodule repository

```
git submodule init
git submodule update
```

### Adding a submodule


### Adding an example

