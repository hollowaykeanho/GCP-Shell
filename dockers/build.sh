#!/bin/bash

NAME="node-app"
VERSION="0.1"


# build docker
docker build -t "${NAME}:{$VERISON}"
