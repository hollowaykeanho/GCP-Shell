#!/bin/bash

CONFIG="./k8s.yaml"


# to reverse kubectl apply / to delete a set of configuration
kubectl delete -f "$CONFIG"
