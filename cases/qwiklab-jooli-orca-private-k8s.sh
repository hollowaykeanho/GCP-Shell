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

export PROJECT="$(gcloud config get-value project)"




# create new security role
export ROLE="orca_storage_update"
export ROLE_TITLE="Orca Storage Update"
export ROLE_DESCRIPTION="add and update objects in Google Cloud Storage bucket"
export ROLE_STAGE="ALPHA"
export ROLE_PERMISSION="\
storage.buckets.get\
,storage.objects.get\
,storage.objects.list\
,storage.objects.update\
,storage.objects.create\
"
gcloud iam roles create "$ROLE" \
	--project "$PROJECT" \
	--title "$ROLE_TITLE" \
	--description "$ROLE_DESCRIPTION" \
	--stage "$ROLE_STAGE" \
	--permissions "$ROLES_PERMISSION"




# create service account
export SVC_ACC="orca-private-cluster-sa"
export SVC_ACC_DESCRIPTION="Orca Private Cluster Service Account"
gcloud iam service-accounts create "$SVC_ACC" \
	--display-name "$SVC_ACC_DESCRIPTION"




# bind IAM roles to service account
export SVC_ACC_EMAIL="${SVC_ACC}@${PROJECT}.iam.gserviceaccount.com"
gcloud projects add-iam-policy-binding "$PROJECT" \
	--member "serviceAccount:${SVC_ACC_EMAIL}" \
	--role "roles/monitoring.viewer"
gcloud projects add-iam-policy-binding "$PROJECT" \
	--member "serviceAccount:${SVC_ACC_EMAIL}" \
	--role "roles/monitoring.metricWriter"
gcloud projects add-iam-policy-binding "$PROJECT" \
	--member "serviceAccount:${SVC_ACC_EMAIL}" \
	--role "roles/logging.logWriter"
gcloud projects add-iam-policy-binding "$PROJECT" \
	--member "serviceAccount:${SVC_ACC_EMAIL}" \
	--role "projects/${PROJECT}/roles/${ROLE}"




# create private k8s
export BASTION="orca-jumphost"
export ZONE="us-east1-b"   # get from jumphost network zoning
BASTION_IP="$(gcloud compute instances describe "$BASTION" --zone "$ZONE" \
	--format='get(networkInterfaces[0].networkIP)')"
export SUBNET="orca-build-subnet"
export NETWORK="orca-build-vpc"

export CLUSTER="orca-test-cluster"
export CLUSTER_NODES="1"
export CLUSTER_MACHINE_TYPE="n1-standard-1"
export CLUSTER_MASTER_SUBNET="10.142.0.0/28" # determine from network region

gcloud config set compute/zone "$ZONE"
gcloud container clusters create "$CLUSTER" \
	--zone "$ZONE" \
	--num-nodes "$CLUSTER_NODES" \
	--network "$NETWORK" \
	--subnetwork "$SUBNET" \
	--machine-type "$CLUSTER_MACHINE_TYPE" \
	--service-account "$SVC_ACC_EMAIL" \
	--enable-private-nodes \
	--enable-private-endpoint \
	--enable-master-authorized-networks \
	--master-authorized-networks "${BASTION_IP}/32" \
	--master-ipv4-cidr "$CLUSTER_MASTER_SUBNET" \
	--enable-ip-alias




# deploy app
## Enter to JumpHost instance VM


## Create app
export ZONE="us-east1-b"   # re-export in jumphost
export CLUSTER="orca-test-cluster" # re-export in jumphost
gcloud container clusters get-credentials "$CLUSTER" \
	--internal-ip \
	--zone "$ZONE"

export APP="hello-server"
export APP_IMAGE="gcr.io/google-samples/hello-app:1.0"
export APP_PORT="8080"
export LOAD_BALANCER="${APP}"
export LOAD_BALANCER_PORT="80"
kubectl create deployment "$APP" --image="$APP_IMAGE"
kubectl expose deployment "$APP" \
	--name "$LOAD_BALANCER" \
	--type LoadBalancer \
	--port "$LOAD_BALANCER_PORT" \
	--target-port "$APP_PORT"
