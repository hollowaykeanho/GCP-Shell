#!/bin/bash

REGION="us-central1"
ZONE="${REGION}-a"

NAME="www1"
NETWORK="team-vpc"
TAG="function1"
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
	--network "$NETWORK" \
	--zone "$ZONE" \
	--tags "$TAG" \
	--metadata startup-script="$STARTUP_SCRIPT"
