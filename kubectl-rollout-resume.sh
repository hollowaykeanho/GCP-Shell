#!/bin/bash

NAME="deployment/hello"


# resume a rolling update
kubectl rollout resume "$NAME"
