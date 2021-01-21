#!/bin/bash

BUCKET="my-google-storage-bucket"
NAME="helloWorld"
TRIGGER="hello_world"
RUNTIME="nodejs10"


# 1. create google storage bucket first
# See gsutil-bucket-create.sh


# 2. create function
gcloud functions deploy "$NAME" \
	--stage-bucket "$BUCKET" \
	--trigger-topic "$TRIGGER" \
	--runtime "$RUNTIME"
