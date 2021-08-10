# The Common Workflow Language for Earth Observation Guide

## TL;DR

This is a guide with best practices and examples to adopt CWL in Earth Observation workflows

## Contributing

### Building the documentation

Build the mkdocs container image with:

```console
docker build -f Dockerfile -t docs-dev .
```

Build and expose the docs:

```console
docker run --rm -it -p 8000:8000 -v ${PWD}:/docs docs-dev:latest
```

Open your browser at [http://0.0.0.0:8000](http://0.0.0.0:8000)