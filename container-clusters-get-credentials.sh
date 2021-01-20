#!/bin/bash

CLUSTER="my-cluster"


# get Google container's clusters' credentials
gcloud container clusters get-credentials "$CLUSTER"
