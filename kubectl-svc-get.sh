#!/bin/bash

NAME="frontend"
JSON_PATH="{.status.loadBalancer.ingress[0].ip}"


# get scv data
kubectl get svc "$NAME" -o=jsonpath="$JSON_PATH"
