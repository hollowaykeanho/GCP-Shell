#!/bin/bash

CONTAINER="hello-server"
CONTAINER_IMAGE="gcr.io/google-samples/hello-app:1.0"


# 1. You need to get Google Container clusters' credentials first
# (See container-clusters-get-credentials.sh)


# 2. Create K8n's deployment
kubectl create deployment "$CONTAINER" --image="$CONTAINER_IMAGE"
