#!/bin/bash

NETWORK="managementnet"
PROJECT="qwiklabs-gcp-00-1cc9fe3b3f13"
SUBNET_MODE="custom"
MTU="1460"
BGP_ROUTING_MODE="regional"


# create a new VPC network
gcloud compute networks create "$NETWORK" \
	--project "$PROJECT" \
	--subnet-mode "$SUBNET_MODE" \
	--mtu "$MTU" \
	--bgp-routing-mode "$BGP_ROUTING_MODE"
