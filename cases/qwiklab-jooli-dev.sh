#!/bin/bash


gcloud auth list
export REGION="us-east1"
export ZONE="${REGION}-b"

gcloud config set compute/zone "$ZONE"
gcloud config set compute/region "$REGION"


# Task 1
export BURCKET="kraken-photos-bucket"
gsutil mb "$BUCKET"


# Task 2
export TOPIC="kraken-pubsub"
gcloud pubsub topics create "$TOPIC"


# Task 3
# 1. upload the file into bucket and copy it into gshell


# 2. execute function
NAME="thumbnail"
RUNTIME="nodejs10"
TRIGGER="google.storage.object.finalize"
gcloud functions deploy "$NAME" \
	--runtime "$RUNTIME" \
	--trigger-resource "$BUCKET" \
	--trigger-event "$TRIGGER"
