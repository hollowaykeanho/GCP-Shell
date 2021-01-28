#!/bin/bash

IMAGE="node-app"
VERSION="0.2"

TAG="gcr.io/qwiklabs-gcp-02-d04f58b0fe4e/node-app:0.2"


# tag an image
docker tag "${IMAGE}:${VERSION}" "$TAG"
