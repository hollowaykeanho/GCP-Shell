#!/bin/bash


PROJECT="$(gcloud info --format='value(config.project)')"
CONFIG="pipeline.json"
SPINNAKER_URL="http://localhost:8080/gate"

sed s/PROJECT/$PROJECT/g spinnaker/pipeline-deploy.json > "$CONFIG"



# create spin pipeline for application
./spin pipeline save --gate-endpoint "$SPINNAKER_URL" -f "$CONFIG"
