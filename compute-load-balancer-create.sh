#!/bin/bash

# CREATE LOAD BALANACER
NETWORK_NAME="network-1b-ip-1"
REGION="us-central1"
HEALTH_CHECK="basic-check"

POOL_NAME="www-pool"
POOL_INSTANCES="www1,www2,www3"
POOL_FORWARDING_RULE="www-rule"


# 1. Create static external IP for load balancer
gcloud compute addresses create "$NETWORK_NAME" --region "$REGION"


# 2. Add HTTP health check
gcloud compute http-health-checks create "$HEALTH_CHECK"


# 3. Add target pool
gcloud compute target-pools create "$POOL_NAME" \
	--region "$REGION" \
	--http-health-check "$HEALTH_CHECK"


# 4. Add instances to target pool
gcloud compute target-pools add-instances "$POOL_NAME" \
	--instances "$POOL_INSTANCES"


# 5. Add forwarding rule
gcloud compute forwarding-rules create "$POOL_FORWARDING_RULE" \
	--region "$REGION" \
	--port 80 \
	--address "$NETWORK_NAME" \
	--target-pool "$POOL_NAME"
