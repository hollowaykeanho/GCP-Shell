#!/bin/bash

KEYFILE="key.json"
ACCOUNT="cloud-sql-proxy@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com"


# create key from service account
gcloud iam service-accounts key create "$KEYFILE" --iam-account="$ACCOUNT"
