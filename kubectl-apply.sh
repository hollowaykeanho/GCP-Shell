#!/bin/bash

SETTINGS="services/hello-green.yaml"


# update using blue-green deployment
#   if $SETTINGS is blue == rollback
#   if $SETTINGS is green == update
# NOTE: you need 2x resources to facilitate a blue-green deployment.
kubectl apply -f "$SETTINGS"
