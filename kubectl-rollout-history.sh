#!/bin/bash

NAME="deployment/hello"


# see a rollout entry in history
kubectl rollout history "$NAME"
