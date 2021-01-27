#!/bin/bash

USER="spinnaker-account"


# get email from IAM
SA_EMAIL="$(gcloud  iam service-accounts list \
	--filter="displayName="$USER" \
	--format='value(email)')"
