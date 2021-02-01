#!/bin/bash

DEPLOYMENT="deployment/prime-server"
REPLICAS="3"


# scale the replica
kubectl scale --replicas "$REPLICAS" "$DEPLOYMENT"
