#!/bin/bash

REGION="us-central1"
ZONE="${REGION}-c"
PROJECT="qwiklabs-gcp-00-1cc9fe3b3f13"


NAME="managementnet-us-vm"
MACHINE_TYPE="f1-micro"
NETWORK="team-vpc"
NETWORK_TIER="PREMIUM"
SUBNET="managementsubnet-us"
IMAGE_FAMILY="debian-10"
IMAGE_PROJECT="debian-cloud"
DISK_SIZE="10GB"
DISK_TYPE="pd-standard"
DISK_NAME="$NAME"
RESERVED_AFFINITY="any"
TAG="function1"
STARTUP_SCRIPT="#! /bin/bash
sudo apt-get update
sudo apt-get install apache2 -y
sudo service apache2 restart
echo '<!doctype html><html><body><h1>${NAME}</h1></body></html>' \
	| tee /var/www/html/index.html"




# create an instance
gcloud compute instances create "$NAME" \
	--machine-type "$MACHINE_TYPE" \
	--image-family "$IMAGE_FAMILY" \
	--image-project "$IMAGE_PROJECT" \
	--network "$NETWORK" \
	--network-tier "$NETWORK_TIER" \
	--subnet "$SUBNET" \
	--boot-disk-size "$DISK_SIZE" \
	--boot-disk-type "$DISK_TYPE" \
	--boot-disk-device-name "$DISK_NAME" \
	--no-shielded-secure-boot \
	--shielded-vtpm \
	--shielded-integrity-monitoring \
	--reservation-affinity="$RESERVED_AFFINITY" \
	--zone "$ZONE" \
	--tags "$TAG" \
	--metadata startup-script="$STARTUP_SCRIPT"
