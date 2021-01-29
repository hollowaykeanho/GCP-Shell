#!/bin/bash

NAMESPACE="production"
SERVICE="gceme-frontend"
DATA=".status.loadBalancer.ingress[0].ip"


# get externel ip from pod's ingress
kubectl get -o jsonpath="{$DATA}" \
	--namespace="$NAMESPACE" \
	services "$SERVICE"
