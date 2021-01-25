#!/bin/bash

NAME="network-1b-ip-1"
REGION="us-central1"

# create static external IP
gcloud compute addresses create "$NAME" --region "$REGION"
