#!/bin/bash

SUBSCRIPTION="mySubscription"


# 1. Delete subscription
gcloud pubsub subscriptions delete "$SUBSCRIPTION"
