#!/bin/bash

GROUP="instance-group-1"
BASE_INSTANCE_NAME="$GROUP"
TEMPLATE="instance-template-1"
SIZE="1"
ZONE="us-central1-a"
PROJECT="qwiklabs-gcp-02-2defea3466d7"


# create instance group
gcloud compute instance-groups managed create "$GROUP" \
	--base-instance-name "$BASE_INSTANCE_NAME" \
	--template "$TEMPLATE" \
	--size "$SIZE" \
	--zone "$ZONE" \
	--project="$PROJECT"
