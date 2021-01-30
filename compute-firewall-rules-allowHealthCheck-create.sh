#!/bin/bash

NAME="app-allow-health-check"
NETWORK="my-internal-app"
DIRECTION="INGRESS"
ACTION="ALLOW"
RULES="tcp"
SOURCE_RANGES="130.211.0.0/22,35.191.0.0/16"
PRIORITY="1000"
TARGET_TAGS="lb-backend"
PROJECT="qwiklabs-gcp-00-1cc9fe3b3f13"  # optional argument


# create new firewall rule for http health check
gcloud compute firewall-rules create "$NAME" \
	--network "$NETWORK" \
	--direction "$DIRECTION" \
	--action "$ACTION" \
	--rules "$RULES" \
	--source-ranges "$SOURCE_RANGES" \
	--priority "$PRIORITY" \
	--target-tags "$TARGET_TAGS" \
	--project "$PROJECT"
