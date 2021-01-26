#!/bin/bash

PROJECT="example-project-id-1"
USER="user@gmail.com"
ROLE="roles/editor"


# remove access for user
gcloud projects remove-iam-policy-binding "$PROJECT" \
	--member "user:{$USER}" \
	--role "$ROLE"
