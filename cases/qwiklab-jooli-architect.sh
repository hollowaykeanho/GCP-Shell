#!/bin/bash

# authenticate gcloud
gcloud auth list




# configure location
export REGION="us-east1"
export ZONE="${REGION}-b"
export STANDARD_MACHINE_TYPE="n1-standard-1"
gcloud config set compute/zone "$ZONE"
gcloud config set compute/region "$REGION"




# create the network
## 1. Edit the file and check all fields
NETWORK_CONFIG="/work/dm/prod-network.yaml"
sed -i s/SET_REGION/"${REGION}"/g "$NETWORK_CONFIG"

## 2. deploy using deplyoment manager
gcloud deployment-manager deployments create prod-network \
	--config "$NETWORK_CONFIG"




# create k8n cluster
export CLUSTER="kraken-prod"
export CLUSTER_NODES="2"
export PROD_NETWORK="kraken-prod-vpc"
export PROD_SUBNET="kraken-prod-subnet"
gcloud container clusters create "$CLUSTER" \
	--zone "$ZONE" \
	--num-nodes "$CLUSTER_NODES" \
	--network "$PROD_NETWORK" \
	--subnetwork "$PROD_SUBNET" \
	--machine-type "$STANDARD_MACHINE_TYPE"
gcloud container clusters get-credentials "$CLUSTER"

## create all applications
export WORKPATH="/work/k8s"
for i in "${WORKPATH}"/*.yaml; do
	kubectl create -f "$i"
done




# create admin instance with both nic
export ADMIN="kraken-admin"
export MGMT_NETWORK="kraken-mgmt-vpc"
export MGMT_SUBNET="kraken-mgmt-subnet"
gcloud compute instances create "$ADMIN" \
	--machine-type "$STANDARD_MACHINE_TYPE" \
	--network-interface "network=${MGMT_NETWORK},subnet=${MGMT_SUBNET}"
	--network-interface "network=${PROD_NETWORK},subnet=${PROD_SUBNET}"

## setup monitoring alert in the GUI interface




# Port-forward spinnaker
## Menu > k8n Engine > Services & Ingress > spin-deck
## Select port forward
## Run gshell command
## open web preview
## open a new gshell preview
export APP="sample-app"
gcloud source repos clone "$APP"
cd "$APP"
touch "a"
git config --global user.email "$(gcloud config get-value account)"
git config --global user.name "Padawan"
git commit -a -m "new changes"
git tag v1.0.1
git push tag
## go to Spinnaker and make sure you deploy the output before checking
