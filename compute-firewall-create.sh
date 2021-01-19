#!/bin/bash

NAME="www-firewall-network-1b"
TAG="network-1b-tag"
ALLOW_RULES="tcp:80"

# create firewall rule
gcloud compute firewall-rules create "$NAME" \
	--target-tags "$TAG" \
	--allow "$ALLOW_RULES"
