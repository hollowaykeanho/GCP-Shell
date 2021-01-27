#!/bin/bash

LOCAL_PORT="8080"
REMOTE_PORT="9000"


# get spin deck info from pods
SPIN_DECK="$(kubectl get pods --namespace default \
	-l "cluster=spin-deck" \
	-o jsonpath="{.items[0].metadata.name})"


# port-forward from remote:9000 to local:8080
kubectl port-forward --namespace default "$SPIN_DECK" \
	"${LOCAL_PORT}:{$REMOTE_PORT}" >> /dev/null
