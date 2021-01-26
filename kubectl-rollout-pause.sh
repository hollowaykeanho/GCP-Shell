#!/bin/bash

NAME = "deployment/hello"


# pause a rollout
kubectl rollout pause "$NAME"
