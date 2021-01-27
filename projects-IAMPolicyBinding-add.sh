#!/bin/bash

PROJECT="my-project"
ROLE="roles/storage.admin"
MEMBER_TYPE="serviceAccount"
EMAIL="spinnaker-account@qwiklabs-gcp-02-114849b13503.iam.gserviceaccount.com"


# add iam policy binding for service account into project
gcloud projects add-iam-policy-binding "$PROJECT" \
	--role "$ROLE" \
	--member "${MEMBER_TYPE}:"${EMAIL}"
