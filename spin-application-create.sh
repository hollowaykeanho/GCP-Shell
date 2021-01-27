#!/bin/bash

SPIN="./spin"
APP_NAME="sample"
SPINNAKER_URL="http://localhost:8080/gate"


# create application using spin
"$SPIN" application save --application-name "$APP_NAME" \
	--owner-email "$(gcloud config get-value core/account)" \
	--cloud-providers kubernetes \
	--gate-endpoint "$SPINNAKER_URL"
