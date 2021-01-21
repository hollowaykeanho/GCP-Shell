#!/bin/bash

NAME="myTopic"


# 1. Delete pubsub topic
gcloud pubsub topics delete "$NAME"
