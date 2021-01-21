#!/bin/bash

TOPIC="myTopic"


# 1. List all subscriptions for a topic
gcloud pubsub topics list-subscriptions "$TOPIC"
