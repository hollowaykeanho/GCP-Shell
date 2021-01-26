#!/bin/bash

CLUSTER="hello-server"
CLUSTER_NETWORK_TYPE="LoadBalancer"
CLUSTER_NETWORK_PORT="8080"


# 1. You need to get Google Container clusters' credentials first
# (See container-clusters-get-credentials.sh)


# 2. Expose Google Container's cluster's external IP
kubectl expose deployment "$CLUSTER" \
	--type="$CLUSTER_NETWORK_TYPE" \
	--port="$CLUSTER_NETWORK_PORT"
