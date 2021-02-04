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




# authenticate into project
gcloud auth list

## configure default region and zone
export REGION="us-east1"
export ZONE="us-east1-b"
export STANDARD_MACHINE="n1-standard-1"
export STANDARD_IMAGE="debian-10"
export STANDARD_IMAGE_PROJECT="debian-cloud"
export STANDARD_DISK_SIZE="10GB"
export STANDARD_DISK_TYPE="pd-standard"
gcloud config set compute/region "$REGION"
gcloud config set compute/zone "$ZONE"




# create vpc network
export NETWORK="griffin-dev-vpc"
export SUBNET_MODE="custom"
export MTU="1460"
export BGP_ROUTING_MODE="regional"
gcloud compute networks create "$NETWORK" \
	--subnet-mode "$SUBNET_MODE" \
	--mtu "$MTU" \
	--bgp-routing-mode "$BGP_ROUTING_MODE"

## create subnet for vpc network
export SUBNET_WP="griffin-dev-wp"
export SUBNET_WP_RANGE="192.168.16.0/20"
export SUBNET_DEV="griffin-dev-mgmt"
export SUBNET_DEV_RANGE="192.168.32.0/20"

gcloud compute networks subnets create "$SUBNET_WP" \
	--range="$SUBNET_WP_RANGE" \
	--network="$NETWORK" \
	--region="$REGION"

gcloud compute networks subnets create "$SUBNET_DEV" \
	--range="$SUBNET_DEV_RANGE" \
	--network="$NETWORK" \
	--region="$REGION"




# copy all contents from google storage
export SOURCE="gs://cloud-training/gsp321/dm"
export NETWORK_DM="griffin-dm"
gsutil cp -r "$SOURCE" .
cd ./dm

## Use deployment manager configuration and create production
echo "imports:
- path: prod-network.jinja

resources:
- name: prod-network
  type: prod-network.jinja
  properties:
    region: $REGION" > ./prod-network.yaml

gcloud deployment-manager deployments create "$NETWORK_DM" \
	--config ./prod-network.yaml

cd ..




# Create bastion host
export BASTION="bastion-host"
export BASTION_AFFINITY="any"
export PROD_NETWORK="griffin-prod-vpc"
export PROD_SUBNET_MGT="griffin-prod-mgmt"

gcloud compute instances create "$BASTION" \
	--machine-type "$STANDARD_MACHINE" \
	--image-family "$STANDARD_IMAGE" \
	--image-project "$STANDARD_IMAGE_PROJECT" \
	--network-interface "network=${NETWORK},subnet=${SUBNET_DEV}" \
	--network-interface "network=${PROD_NETWORK},subnet=${PROD_SUBNET_MGT}" \
	--boot-disk-size "$STANDARD_DISK_SIZE" \
	--boot-disk-type "$STANDARD_DISK_TYPE" \
	--boot-disk-device-name "$BASTION" \
	--no-shielded-secure-boot \
	--shielded-vtpm \
	--shielded-integrity-monitoring \
	--reservation-affinity="$BASTION_AFFINITY" \
	--zone "$ZONE"

## create firewall for both development and production networks
export FIREWALL="wp-allow-icmp-ssh-rdp"
export FIREWALL_DIRECTION="INGRESS"
export FIREWALL_ACTION="ALLOW"
export FIREWALL_RULES="tcp:22,tcp:3389,icmp"
export FIREWALL_SOURCE_RANGES="0.0.0.0/0"
export FIREWALL_PRIORITY="1000"
gcloud compute firewall-rules create "dev-$FIREWALL" \
	--network "$NETWORK" \
	--direction "$FIREWALL_DIRECTION" \
	--action "$FIREWALL_ACTION" \
	--source-ranges="$FIREWALL_SOURCE_RANGES" \
	--rules "$FIREWALL_RULES" \
	--priority "$FIREWALL_PRIORITY"

gcloud compute firewall-rules create "prod-$FIREWALL" \
	--network "$PROD_NETWORK" \
	--direction "$FIREWALL_DIRECTION" \
	--action "$FIREWALL_ACTION" \
	--source-ranges="$FIREWALL_SOURCE_RANGES" \
	--rules "$FIREWALL_RULES" \
	--priority "$FIREWALL_PRIORITY"




# Create Cloud SQL
export SQL="griffin-dev-db"
export SQL_AVAILABILITY="regional"
export SQL_VERSION="MYSQL_8_0"
export SQL_TIER="db-n1-standard-1"
export SQL_ROOT_PASSWORD="myR0()Ttesting123"
gcloud sql instances create "$SQL" \
	--availability-type="$SQL_AVAILABILITY" \
	--backup \
	--database-version="$SQL_VERSION" \
	--tier "$SQL_TIER" \
	--root-password "$SQL_ROOT_PASSWORD" \
	--enable-bin-log \
	--region "$REGION"

1>&2 echo "Open a new gshell tab and proceed with 'wp_user' creation in SQL..."
read -n 1 -s -r -p "Press any key after completion to continue."

## $ gcloud sql connect "$SQL" --user="root"
## > CREATE DATABASE wordpress;
## > CREATE USER 'wp_user'@'%' IDENTIFIED BY 'stormwind_rules';
## > GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_user'@'%';
## > FLUSH PRIVILEGES;




# Create K8n cluster
export CLUSTER="griffin-dev"
export CLUSTER_NODES="2"
export CLUSTER_MACHINE_TYPE="n1-standard-4"
gcloud container clusters create "$CLUSTER" \
	--machine-type "$CLUSTER_MACHINE_TYPE" \
	--zone "$ZONE" \
	--num-nodes "$CLUSTER_NODES" \
	--network "$NETWORK" \
	--subnetwork "$SUBNET_WP"




# Prepare K8n cluster
export SOURCE="gs://cloud-training/gsp321/wp-k8s"
gsutil cp "$SOURCE" .
cd ./wp-k8s

## create cloudsql-instance-credentails entry
gcloud iam service-accounts keys create key.json \
    --iam-account=cloud-sql-proxy@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com
kubectl create secret generic cloudsql-instance-credentials \
    --from-file key.json

##  modify values to match requirements
echo "kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: wordpress-volumeclaim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 200Gi
---
apiVersion: v1
kind: Secret
metadata:
  name: database
type: Opaque
stringData:
  username: wp_user
  password: stormwind_rules" > wp-env.yaml
kubectl apply -f wp-env.yaml

## !!! replace the wy-deployment.yaml connection URI before proceeding.
1>&2 echo "Open new shell and edit wy-deployment.yaml as instructed."
read -n 1 -s -r -p "Upon completion, press any key to continue..."

kubectl apply -f wp-deployment.yaml
kubectl apply -f wp-service.yaml

cd ..




# Add IAM member as editor
1>&2 echo "Add IAM member with editor permission."
