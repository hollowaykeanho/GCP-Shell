#!/bin/bash

PROJECT="$(gcloud config get-value project)"
ROLE="roles/container.developer"
MEMBER="serviceAccount:demo-developer@${PROJECT}.iam.gserviceaccount.com"


# bind iam to policy
gcloud projects add-iam-policy-binding "$PORJECT" \
	--role="$ROLE" \
	--member="$MEMBER"
