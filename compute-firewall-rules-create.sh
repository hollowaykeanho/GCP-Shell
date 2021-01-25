#!/bin/bash

NAME="managementnet-allow-icmp-ssh-rdp"
NETWORK="managementnet"
DIRECTION="INGRESS"
ACTION="ALLOW"
RULES="tcp:22,tcp:3389,icmp"
SOURCE_RANGES="0.0.0.0/0"
PRIORITY="1000"
PROJECT="qwiklabs-gcp-00-1cc9fe3b3f13"


# create new firewall rule
gcloud compute firewall-rules create "$NAME" \
	--network "$NETWORK" \
	--direction "$DIRECTION" \
	--action "$ACTION" \
	--rules "$RULES" \
	--source-ranges "$SOURCE_RANGES" \
	--priority "$PRIORITY" \
	--project "$PROJECT"
