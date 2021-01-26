#!/bin/bash

ORGANIZATION="myORG"
USER="user@gmail.com"
ROLE="roles/editor"


# remove access for user
gcloud organizations remove-iam-policy-binding "$ORGANIZATION" \
	--member "user:{$USER}" \
	--role "$ROLE"
