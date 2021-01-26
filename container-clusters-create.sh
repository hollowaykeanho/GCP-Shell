#!/bin/bash

REGION="us-central1"
ZONE="${REGION}-b"

CLUSTER="my-cluster"
CLUSTER_NODES="2"
CLUSTER_NETWORK="team-vpc"
CLUSTER_MACHINE_TYPE="n1-standard-4"


# create Google container clusters
gcloud container clusters create "$CLUSTER" \
	--zone "$ZONE" \
	--num-nodes "$CLUSTER_NODES" \
	--network "$CLUSTER_NETWORK" \
	--machine-type "$CLUSTER_MACHINE_TYPE"
