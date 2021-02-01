#!/bin/bash


INSTANCE="vm-webserver"
ZONE="us-central1-a"


# to ssh into the instance
gcloud compute ssh "$INSTANCE" "$ZONE"
