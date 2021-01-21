#!/bin/bash

TOPIC="myTopic"


# 1. Publish a message to a topic
gcloud pubsub topics publish "$TOPIC" --message "Hello"
