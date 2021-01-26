#!/bin/bash

NAME="deployments/auth.yaml"


# create a container file
kubectl create -f "$NAME"
