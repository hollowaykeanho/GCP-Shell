#!/bin/bash
#
# Copyright 2021 "Holloway" Chew, Kean Ho <hollowaykeanho@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

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
	--network-interface "network=${NETWORK},subnet=${SUBNET}" \
	--network-tier "$NETWORK_TIER" \
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
