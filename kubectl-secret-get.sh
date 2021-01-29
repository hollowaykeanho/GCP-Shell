#!/bin/bash


# get secret from cluster
CLUSTER="cd-jenkins"
DATA="data.jenkins-admin-password"
PASSWORD="$(kubectl get secret "$CLUSTER" -o jsonpath="$DATA" | base64 --decode)"
