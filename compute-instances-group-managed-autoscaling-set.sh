#!/bin/bash

GROUP="instance-group-1"
PROJECT="qwiklabs-gcp-02-2defea3466d7"
ZONE="us-central1-a"
COOLDOWN="45"
MAX_REPLICAS="5"
MIN_REPLICAS="1"
TARGET_CPU_USE="0.8"
MODE="on"


# set managed instance groups (Google Compute Engine)
gcloud beta compute instance-groups managed set-autoscaling "$GROUP" \
	--zone "$ZONE" \
	--cool-down-period "$COOLDOWN" \
	--min-num-replicas "$MIN_REPLICAS" \
	--max-num-replicas "$MAX_REPLICAS" \
	--target-cpu-utilization "$TARGET_CPU_USE" \
	--mode "$MODE"
