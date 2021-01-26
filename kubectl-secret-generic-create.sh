#!/bin/bash

KEYFILE="key.json"
NAME="cloudsql-instance-credentials"


# create a generic secret
kubectl create secret generic "$NAME" --from-file "$KEYFILE"
