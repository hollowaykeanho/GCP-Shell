#!/bin/bash

BUCKET="gs://my-own-bucket-1231123"
CLASS="STANDARD" # See: https://cloud.google.com/storage/docs/storage-classes
LOCATION="ASIA" # See: https://cloud.google.com/storage/docs/locations
PROJECT_ID="Your-Project-ID"
#RETENTION="1y"


# create bucket
# gsutil mb gs://YOUR-NAME-HERE
gsutil mb "$BUCKET" -c "$CLASS" -l "$LOCATION" -p "$PROJECT_ID" #--retention "$RETENTION"
