#!/bin/bash

ORGANIZATION="myORG"
USER="user@gmail.com"
ROLE="roles/editor"
CONDITION='expression=request.time <
 timestamp("2019-01-01T00:00:00Z"),title=expires_end_of_2018,descrip\
tion=Expires at midnight on 2018-12-31'


# add access for user
gcloud organizations add-iam-policy-binding "$ORGANIZATION" \
	--member "user:{$USER}" \
	--role "$ROLE" \
	--condition "$CONDITION"
