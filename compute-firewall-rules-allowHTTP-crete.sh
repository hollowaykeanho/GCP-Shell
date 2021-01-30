#!/bin/bash

NAME="app-allow-http"
NETWORK="my-internal-app"
DIRECTION="INGRESS"
ACTION="ALLOW"
RULES="tcp:80"
SOURCE_RANGES="0.0.0.0/0"
PRIORITY="1000"
TARGET_TAGS="lb-backend"
PROJECT="qwiklabs-gcp-02-2defea3466d7"  # optional argument


# create new firewall rule
gcloud compute firewall-rules create "$NAME" \
	--network "$NETWORK" \
	--direction "$DIRECTION" \
	--action "$ACTION" \
	--rules "$RULES" \
	--source-ranges "$SOURCE_RANGES" \
	--priority "$PRIORITY" \
	--target-tags "$TARGET_TAGS" \
	--project "$PROJECT"
