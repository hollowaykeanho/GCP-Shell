#!/bin/bash

ZONE="us-central1-a"

NAME="www1"
TAG="network-1b-tag"
IMAGE_FAMILY="debian-9"
IMAGE_PROJECT="debian-cloud"
STARTUP_SCRIPT="#! /bin/bash
sudo apt-get update
sudo apt-get install apache2 -y
sudo service apache2 restart
echo '<!doctype html><html><body><h1>${NAME}</h1></body></html>' \
	| tee /var/www/html/index.html"


# create an instance
gcloud compute instances create "$NAME" \
	--image-family "$IMAGE_FAMILY" \
	--image-project "$IMAGE_PROJECT" \
	--zone "$ZONE" \
	--tags "$TAG" \
	--metadata startup-script="$STARTUP_SCRIPT"
