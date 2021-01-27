#!/bin/bash

USER="spinnaker-account"


# create a service account
gcloud iam service-accounts create "$USER" --display-name "$USER"
