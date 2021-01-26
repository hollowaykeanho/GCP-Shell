#!/bin/bash

NAME="hello"
REPLICAS="5"


# scale the deployment
kubectl scale deployment "$NAME" "$REPLICAS"
