#!/bin/bash
#
# Copyright 2021 "Holloway" Chew, Kean Ho <hollowaykeanho@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

NAME="hello-world"




# run a docker image (if local is not found, pull from remote)
docker run hello-world
## Unable to find image 'hello-world:latest' locally
## latest: Pulling from library/hello-world
## 0e03bdcc26d7: Pull complete
## Digest: sha256:31b9c7d48790f0d8c50ab433d9c3b7e17666d6993084c002c2ff1ca09b96391d
## Status: Downloaded newer image for hello-world:latest
##
## Hello from Docker!
## This message shows that your installation appears to be working correctly.
##
## To generate this message, Docker took the following steps:
##   1. The Docker client contacted the Docker daemon.
##   2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
##      (amd64)
##   3. The Docker daemon created a new container from that image which runs the
##      executable that produces the output you are currently reading.
##   4. The Docker daemon streamed that output to the Docker client, which sent
##      it to your terminal.
##
## To try something more ambitious, you can run an Ubuntu container with:
##   $ docker run -it ubuntu bash
##
## Share images, automate workflows, and more with a free Docker ID:
##   https://hub.docker.com/
##
## For more examples and ideas, visit:
##   https://docs.docker.com/get-started/




# run a docker image with port-forwarding locally (4000 from 80)
PORT_FORWARD="4000:80"
CONTAINER="my-app"
IMAGE="node-app"
VERSION="0.1"

## run in current terminal
docker run -p "$PORT_FORWARD" --name "$CONTAINER" "${IMAGE}:${VERSION}"

## run in background
docker run -p "$PORT_FORWARD" --name "$CONTAINER" -d "${IMAGE}:${VERSION}"
