#!/bin/bash

TOPIC="myTopic"


# 1. Create a pubsub topic
gcloud pubsub topics create "$TOPIC"
