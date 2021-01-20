#!/bin/bash

REGION="us-central1"
ZONE="${REGION}-b"


CLUSTER="my-cluster"

# get Google container's clusters' credentials
gcloud container clusters get-credentials "$CLUSTER" --zone "$ZONE"
