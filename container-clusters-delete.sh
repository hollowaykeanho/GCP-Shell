#!/bin/bash

CLUSTER="my-cluster"


# Delete the cluster
gcloud container clusters delete "$CLUSTER"
