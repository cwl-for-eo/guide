# Containers 101

## Why are containers needed?

The numerous dependencies and compatibilities between tools, librairies, dependencies, OS may lead  to the problem known as the _matrix from hell_: the development or runtime stack required to build or run an end-to-end application.

Containers provide a solution for the problem known as the _matrix from hell_: the development or runtime stack required to build or run an end-to-end application and ease the creation of the environments.

## What containers can do

Containers simplify software installation by providing a complete known-good runtime for software and its dependencies. 

Containers allow running each tool with its own dependencies in separate and isolated containers.

## What are containers

Containers share the kernel: linux host can run linux based containers.

To run a linux container on Windows, Windows runs a container on linux virtual machine running under the hood.

## Containers vs Images

An Image is a template, containers are instantiations of an image.