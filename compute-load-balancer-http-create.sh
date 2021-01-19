#!/bin/bash

# Create Google Front End (GFE) HTTP load balancer

REGION="us-central1"
ZONE="${REGION}-a"


TEMPLATE_NAME="lb-backend-template"
TEMPLATE_NETWORK="default"
TEMPLATE_SUBNET="default"
TEMPLATE_TAGS="allow-health-check"
TEMPLATE_IMAGE_FAMILY="debian-9"
TEMPLATE_STARTUP_SCRIPT='#! /bin/bash
apt-get update
apt-get install apache2 -y
a2ensite default-ssl
a2enmod ssl
vm_hostname="$(curl -H "Metadata-Flavor:Google" \
	http://169.254.169.254/computeMetadata/v1/instance/name)"
echo "Page served from: $vm_hostname" | tee /var/www/html/index.html
systemctl restart apache2'


HTTP_LOAD_BALANCER_GROUP="lb-backend-group"
HTTP_LOAD_BALANCER_SIZE="2"
HTTP_LOAD_BALANCER_IP="lb-ipv4-1"
HTTP_LOAD_BALANCER_IP_VERSION="IPV4"
HTTP_LOAD_BALANCER_HEALTH_CHECK="http-basic-check"
HTTP_LOAD_BALANCER_HEALTH_CHECK_PORT="80"
HTTP_LOAD_BALANCER_BACKEND_SERVICE="web-backend-service"
HTTP_LOAD_BALANCER_URL_MAP="web-map-http"
HTTP_LOAD_BALANCER_PROXY="http-lb-proxy"
HTTP_LOAD_BALANCER_FORWARDING_RULE="http-content-rule"
HTTP_LOAD_BALANCER_PORT="80"


FIREWALL_RULE="fw-allow-health-check"
FIREWALL_NETWORK="default"
FIREWALL_ACTION="allow"
FIREWALL_DIRECTION="ingress"
FIREWALL_SOURCE_RANGES="130.211.0.0/22,35.191.0.0/16"
FIREWALL_TARGET_TAGS="allow-health-check"
FIREWALL_RULES="tcp:80"


# 1. Create load balancer template
gcloud compute instance-templates create "$TEMPLATE_NAME" \
	--region="$REGION" \
	--network="$TEMPLATE_NETWORK" \
	--subnet="$TEMPLATE_SUBNET" \
	--tags="$TEMPLATE_TAGS" \
	--image-family="$TEMPLATE_IMAGE_FAMILY" \
	--metadata=startup-script="$TEMPLATE_STARTUP_SCRIPT"


# 2. Create managed instance group from load balancer template
gcloud compute instance-groups managed create "$HTTP_LOAD_BALANCER_GROUP" \
	--template="$TEMPLATE_NAME" \
	--size="$HTTP_LOAD_BALANCER_SIZE" \
	--zone="$ZONE"


# 3. Setup ingress firewall rules
gcloud compute firewall-rules create "$FIREWALL_RULE" \
	--network="$FIREWALL_NETWORK" \
	--action="$FIREWALL_ACTION" \
	--direction="$FIREWALL_DIRECTION" \
	--source-ranges="$FIREWALL_SOURCE_RANGES" \
	--target-tags="$FIREWALL_TARGET_TAGS" \
	--rules="$FIREWALL_RULES"


# 4. Setup global static external IP
gcloud compute addresses create "$HTTP_LOAD_BALANCER_IP" \
	--ip-version="$HTTP_LOAD_BALANCER_IP_VERSION" \
	--global


# 5. Create health check for load balancer
gcloud compute health-checks create http "$HTTP_LOAD_BALANCER_HEALTH_CHECK" \
	--port "$HTTP_LOAD_BALANCER_HEALTH_CHECK_PORT"


# 6. Create backend service
gcloud compute backend-services create "$HTTP_LOAD_BALANCER_BACKEND_SERVICE" \
	--protocol=HTTP \
	--port-name=http \
	--health-checks="$HTTP_LOAD_BALANCER_HEALTH_CHECK" \
	--global


# 7. Add backend service
gcloud compute backend-services add-backend "$HTTP_LOAD_BALANCER_BACKEND_SERVICE" \
	--instance-group="$HTTP_LOAD_BALANCER_GROUP" \
	--instance-group-zone="$ZONE" \
	--global


# 8. Create URL map route incoming request to default backend service
gcloud compute url-maps create "$HTTP_LOAD_BALANCER_URL_MAP" \
	--default-service "$HTTP_LOAD_BALANCER_BACKEND_SERVICE"


# 9. Create target http proxy
gcloud compute target-http-proxies create "$HTTP_LOAD_BALANCER_PROXY" \
	--url-map "$HTTP_LOAD_BALANCER_URL_MAP"


# 10. Create global forwarding rule to route incoming request to proxy
gcloud compute forwarding-rules create "$HTTP_LOAD_BALANCER_FORWARDING_RULE" \
	--address="$HTTP_LOAD_BALANCER_IP" \
	--global \
	--target-http-proxy="$HTTP_LOAD_BALANCER_PROXY" \
	--ports="$HTTP_LOAD_BALANCER_PORT"
