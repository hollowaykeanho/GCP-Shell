#!/bin/bash

MEMBER_TYPE="serviceAccount"
EMAIL="spinnaker-account@qwiklabs-gcp-02-114849b13503.iam.gserviceaccount.com"
ROLES="roles/pubsub.subscriber"
POLICY="gcr-triggers"


# add service account to read from gcr-triggers subscription
gcloud beta pubsub subscriptions add-iam-policy-binding "$POLICY" \
	--role "$ROLES" \
	--member "${MEMBER_TYPE}:${EMAIL}"
