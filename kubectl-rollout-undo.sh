#!/bin/bash

NAME="deployment/hello"


# undo a rollout (a.k.a rollback)
kubectl rollout undo "$NAME"
