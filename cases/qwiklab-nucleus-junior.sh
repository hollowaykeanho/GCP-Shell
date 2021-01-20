#!/bin/bash


# Login with gcloud
gcloud auth list
export REGION="us-east1"
export ZONE="$REGION-b"

export NUCLEUS_IMAGE_FAMILY="debian-9"
export NUCLEUS_IMAGE_PROJECT="debian-cloud"
export NUCLEUS_NETWORK="nucleus-vpc"
export NUCLEUS_MACHINE_TYPE="f1-micro"
export NUCLEUS_NODE_MACHINE_TYPE="n1-standard-1"
export NUCLEUS_JUMPHOST="nucleus-jumphost"
export NUCLEUS_BACKEND="nucleus-backend"
export NUCLEUS_DEPLOYMENT="nucleus-web-server"
export NUCLEUS_DEPLOYMENT_IMAGE="gcr.io/google-samples/hello-app:2.0"


# Task 1
export INSTANCE="$NUCLEUS_JUMPHOST"
export INSTANCE_NETWORK="$NUCLEUS_NETWORK"
export INSTANCE_MACHINE_TYPE="$NUCLEUS_MACHINE_TYPE"
export INSTANCE_IMAGE_FAMILY="$NUCLEUS_IMAGE_FAMILY"
export INSTANCE_IMAGE_PROJECT="$NUCLEUS_IMAGE_PROJECT"

gcloud compute instances create "$INSTANCE" \
	--network "$INSTANCE_NETWORK" \
	--zone "$ZONE" \
	--machine-type "$INSTANCE_MACHINE_TYPE" \
	--image-family="$INSTANCE_IMAGE_FAMILY" \
	--image-project="$INSTANCE_IMAGE_PROJECT"


# Task 2
export CLUSTER="$NUCLEUS_BACKEND"
export CLUSTER_DEPLOYMENT="$NUCLEUS_DEPLOYMENT"
export CLUSTER_IMAGE="$NUCLEUS_DEPLOYMENT_IMAGE"
export CLUSTER_NODES="1"
export CLUSTER_NETWORK="$NUCLEUS_NETWORK"
export CLUSTER_NETWORK_TYPE="LoadBalancer"
export CLUSTER_NETWORK_PORT="8080"

gcloud container clusters create "$CLUSTER" \
	--region "$REGION" \
	--num-nodes "$CLUSTER_NODES" \
	--network "$CLUSTER_NETWORK"
gcloud container clusters get-credentials "$CLUSTER" --region "$REGION"
kubectl create deployment "$CLUSTER_DEPLOYMENT" --image="$CLUSTER_IMAGE"
kubectl expose deployment "$CLUSTER_DEPLOYMENT" \
	--type="$CLUSTER_NETWORK_TYPE" \
	--port="$CLUSTER_NETWORK_PORT"


# Task 3
cat << EOF > startup.sh
#! /bin/bash
apt-get update
apt-get install -y nginx
service nginx start
sed -i -- 's/nginx/Google Cloud Platform - '"\$HOSTNAME"'/' /var/www/html/index.nginx-debian.html
EOF

export HTTP_LOAD_BALANCER_TEMPLATE_NAME="web-server-template"
export HTTP_LOAD_BALANCER_TEMPLATE_NETWORK="$NUCLEUS_NETWORK"
export HTTP_LOAD_BALANCER_TEMPLATE_IMAGE_MACHINE_TYPE="$NUCLEUS_NODE_MACHINE_TYPE"
export HTTP_LOAD_BALANCER_TEMPLATE_IMAGE_FAMILY="$NUCLEUS_IMAGE_FAMILY"
export HTTP_LOAD_BALANCER_TEMPLATE_IMAGE_PROJECT="$NUCLEUS_IMAGE_PROJECT"
export HTTP_LOAD_BALANCER_GROUP="web-server-group"
export HTTP_LOAD_BALANCER_BASE_INSTANCE_NAME="web-server"
export HTTP_LOAD_BALANCER_SIZE="2"
export HTTP_LOAD_BALANCER_FIREWALL="web-server-firewall"
export HTTP_LOAD_BALANCER_FIREWALL_NETWORK="$NUCLEUS_NETWORK"
export HTTP_LOAD_BALANCER_FIREWALL_ACTION="allow"
export HTTP_LOAD_BALANCER_FIREWALL_DIRECTION="ingress"
export HTTP_LOAD_BALANCER_FIREWALL_SOURCE_RANGES="130.211.0.0/22,35.191.0.0/16"
export HTTP_LOAD_BALANCER_FIREWALL_RULES="tcp:80"
export HTTP_LOAD_BALANCER_HEALTH_CHECK="http-basic-check"
export HTTP_LOAD_BALANCER_HEALTH_CHECK_PORT="80"
export HTTP_LOAD_BALANCER_BACKEND_SERVICE="web-backend-service"
export HTTP_LOAD_BALANCER_URL_MAP="web-server-map"
export HTTP_LOAD_BALANCER_PROXY="http-lb-proxy"
export HTTP_LOAD_BALANCER_FORWARDING_RULE="http-content-rule"
export HTTP_LOAD_BALANCER_PORT="80"

## create instance template
gcloud compute instance-templates create "$HTTP_LOAD_BALANCER_TEMPLATE_NAME" \
	--region="$REGION" \
	--network="$HTTP_LOAD_BALANCER_TEMPLATE_NETWORK" \
	--image-family="$HTTP_LOAD_BALANCER_TEMPLATE_IMAGE_FAMILY" \
	--image-project="$HTTP_LOAD_BALANCER_TEMPLATE_IMAGE_PROJECT" \
	--machine-type="$HTTP_LOAD_BALANCER_TEMPLATE_IMAGE_MACHINE_TYPE" \
	--metadata-from-file startup-script=startup.sh

## create managed instance group
gcloud compute instance-groups managed create "$HTTP_LOAD_BALANCER_GROUP" \
	--base-instance-name "$HTTP_LOAD_BALANCER_BASE_INSTANCE_NAME" \
	--template "$HTTP_LOAD_BALANCER_TEMPLATE_NAME" \
	--size="$HTTP_LOAD_BALANCER_SIZE" \
	--region="$REGION"

## create firewall rules
gcloud compute firewall-rules create "$HTTP_LOAD_BALANCER_FIREWALL" \
	--network="$HTTP_LOAD_BALANCER_FIREWALL_NETWORK" \
	--action="$HTTP_LOAD_BALANCER_FIREWALL_ACTION" \
	--direction="$HTTP_LOAD_BALANCER_FIREWALL_DIRECTION" \
	--source-ranges="$HTTP_LOAD_BALANCER_FIREWALL_SOURCE_RANGES" \
	--rules="$HTTP_LOAD_BALANCER_FIREWALL_RULES"

## create health check for load balancer
gcloud compute http-health-checks create "$HTTP_LOAD_BALANCER_HEALTH_CHECK" \
	--port "$HTTP_LOAD_BALANCER_HEALTH_CHECK_PORT"

## set named ports to instance group
gcloud compute instance-groups managed set-named-ports "$HTTP_LOAD_BALANCER_GROUP" \
	--named-ports "http:80" \
	--region "$REGION"

## create backend service
gcloud compute backend-services create "$HTTP_LOAD_BALANCER_BACKEND_SERVICE" \
	--protocol=HTTP \
	--port-name=http \
	--http-health-checks="$HTTP_LOAD_BALANCER_HEALTH_CHECK" \
	--global

## add backend service
gcloud compute backend-services add-backend "$HTTP_LOAD_BALANCER_BACKEND_SERVICE" \
	--instance-group="$HTTP_LOAD_BALANCER_GROUP" \
	--instance-group-region="$REGION" \
	--global

## create URL map routing
gcloud compute url-maps create "$HTTP_LOAD_BALANCER_URL_MAP" \
	--default-service "$HTTP_LOAD_BALANCER_BACKEND_SERVICE"

## create target http proxy
gcloud compute target-http-proxies create "$HTTP_LOAD_BALANCER_PROXY" \
	--url-map "$HTTP_LOAD_BALANCER_URL_MAP"

## create global forwarding rlue to route incoming request to proxy
gcloud compute forwarding-rules create "$HTTP_LOAD_BALANCER_FORWARDING_RULE" \
	--global \
	--target-http-proxy="$HTTP_LOAD_BALANCER_PROXY" \
	--ports="$HTTP_LOAD_BALANCER_PORT"
