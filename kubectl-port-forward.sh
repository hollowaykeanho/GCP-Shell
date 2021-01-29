#!/bin/bash

LOCAL_PORT="8080"
REMOTE_PORT="9000"


# Method A) 1. get spin deck info from pods
SPIN_DECK="$(kubectl get pods --namespace default \
	-l "cluster=spin-deck" \
	-o jsonpath="{.items[0].metadata.name})"

## Method A) 2. port-forward from remote:9000 to local:8080
kubectl port-forward --namespace default "$SPIN_DECK" \
	"${LOCAL_PORT}:{$REMOTE_PORT}" &> /dev/null




# Method B) 1. get pod name
CLUSTER_NAME="jenkins-master"
POD_NAME=$(kubectl get pods --namespace default \
	-l "app.kubernetes.io/component=${CLUSTER_NAME}" \
	-l "app.kubernetes.io/instance=cd" \
	-o jsonpath="{.items[0].metadata.name}")

## Method B) 2. port-forward
kubectl port-forward "$POD_NAME" "${LOCAL_PORT}:${REMOTE_PORT}" &> /dev/null
