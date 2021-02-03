#!/bin/bash

ZONE="us-central-1"

POOL="second-pool"
CLUSTER="simplecluster"
NUM_NODES="1"


# creates contained secured pool
gcloud beta container node-pools create "$POOL" \
	--zone=$MY_ZONE \
	--cluster="$CLUSTER" \
	--num-nodes="$NUM_NODES" \
	--metadata=disable-legacy-endpoints=true \
	--workload-metadata-from-node=SECURE
