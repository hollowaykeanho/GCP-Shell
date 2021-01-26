#!/bin/bash

NAME="deployment/hello"


# get current rollout status
kubectl rollout status "$NAME"
