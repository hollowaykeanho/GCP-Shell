#!/bin/bash

REGION="us-central1"

SUBNET="managementsubnet-us"
NETWORK="managementnet"
PROJECT="qwiklabs-gcp-00-1cc9fe3b3f13"
RANGE="10.130.0.0/20"


# create subnet for existing VPC network
gcloud compute networks subnets create "$SUBNET" \
	--project "$PROJECT" \
	--range="$RANGE" \
	--network="$NETWORK" \
	--region="$REGION"
