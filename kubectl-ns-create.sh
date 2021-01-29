#!/bin/bash

NAME="production"


# create a new kubernetes namespace
kubectl create ns "$NAME"
