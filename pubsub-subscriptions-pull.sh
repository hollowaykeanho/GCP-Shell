#!/bin/bash

SUBSCRIPTION="mySubscription"
LIMIT="20"


# 1. Pull subscription messages
gcloud pubsub subscriptions pull "$SUBSCRIPTION" --auto-ack --limit="$LIMIT"
