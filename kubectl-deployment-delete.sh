#!/bin/bash

NAME="deployment/simple-deployment"
SERVICE="svc/simple-service"


# delete a deployed instance
kubectl delete "$NAME"


# delete a deployed service
kubectl delete "$SERVICE"
