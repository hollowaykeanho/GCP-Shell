#!/bin/bash

TOPIC="myTopic"
SUBSCRIPTION="mySubscription"


# 1. Create pubsub subscriptions
gcloud pubsub subscriptions create --topic "$TOPIC" "$SUBSCRIPTION"
