#!/bin/bash

PROJECT="example-project-id-1"
USER="user@gmail.com"
ROLE="roles/editor"
CONDITION='expression=request.time <
 timestamp("2019-01-01T00:00:00Z"),title=expires_end_of_2018,descrip\
tion=Expires at midnight on 2018-12-31'


# add access for user
gcloud projects add-iam-policy-binding "$PROJECT" \
	--member "user:{$USER}" \
	--role "$ROLE" \
	--condition "$CONDITION"
