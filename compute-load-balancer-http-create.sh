#!/bin/bash

# Create Google Front End (GFE) HTTP load balancer

REGION="us-central1"
ZONE="${REGION}-a"
NETWORK="team-vps"


LOAD_BALANCER_TEMPLATE_NAME="lb-backend-template"
LOAD_BALANCER_TEMPLATE_NETWORK="$NETWORK"
LOAD_BALANCER_TEMPLATE_IMAGE_MACHINE_TYPE="f1-micro"
LOAD_BALANCER_TEMPLATE_IMAGE_FAMILY="debian-10"
LOAD_BALANCER_TEMPLATE_IMAGE_PROJECT="debian-cloud"
LOAD_BALANCER_TEMPLATE_TAGS="system1"
LOAD_BALANCER_TEMPLATE_STARTUP_SCRIPT='#! /bin/bash
apt-get update
apt-get install apache2 -y
a2ensite default-ssl
a2enmod ssl
vm_hostname="$(curl -H "Metadata-Flavor:Google" \
	http://169.254.169.254/computeMetadata/v1/instance/name)"
echo "Page served from: $vm_hostname" | tee /var/www/html/index.html
systemctl restart apache2'

LOAD_BALANCER_GROUP="lb-backend-group"
LOAD_BALANCER_BASE_NAME="load-balancer"
LOAD_BALANCER_SIZE="2"

LOAD_BALANCER_FIREWALL="lb-backend-firewall"
LOAD_BALANCER_FIREWALL_NETWORK="$NETWORK"
LOAD_BALANCER_FIREWALL_ACTION="allow"
LOAD_BALANCER_FIREWALL_DIRECTION="ingress"
LOAD_BALANCER_FIREWALL_SOURCE_RANGES="130.211.0.0/22,35.191.0.0/16"
LOAD_BALANCER_FIREWALL_RULES="tcp:80"

LOAD_BALANCER_NAMED_PORTS="http:80"

LOAD_BALANCER_HEALTH_CHECK="http-basic-check"
LOAD_BALANCER_HEALTH_CHECK_PORT="80"

LOAD_BALANCER_BACKEND_SERVICE="web-backend-service"
LOAD_BALANCER_BACKEND_SERVICE_PROTOCOL="HTTP"
LOAD_BALANCER_BACKEND_SERVICE_PORT_NAME="http"
LOAD_BALANCER_URL_MAP="web-map-http"
LOAD_BALANCER_PROXY="http-lb-proxy"
LOAD_BALANCER_FORWARDING_RULE="http-content-rule"
LOAD_BALANCER_PORT="80"



# 1. Create load balancer template
gcloud compute instance-templates create "$LOAD_BALANCER_TEMPLATE_NAME" \
	--zone="$ZONE" \
	--network="$LOAD_BALANCER_TEMPLATE_NETWORK" \
	--machine-type="$LOAD_BALANCER_TEMPLATE_IMAGE_MACHINE_TYPE" \
	--image-family="$LOAD_BALANCER_TEMPLATE_IMAGE_FAMILY" \
	--image-project="$LOAD_BALANCER_TEMPLATE_IMAGE_PROJECT" \
	--tags="$LOAD_BALANCER_TEMPLATE_TAGS" \
	--metadata=startup-script="$TEMPLATE_STARTUP_SCRIPT"


# 2. Create managed instance group
gcloud compute instance-groups managed create "$LOAD_BALANCER_GROUP" \
	--template "$LOAD_BALANCER_TEMPLATE_NAME" \
	--base-instance-name "$LOAD_BALANCER_BASE_NAME" \
	--size="$LOAD_BALANCER_SIZE" \
	--zone="$ZONE"


# 3. Setup ingress firewall rules
gcloud compute firewall-rules create "$LOAD_BALANCER_FIREWALL" \
	--network="$LOAD_BALANCER_FIREWALL_NETWORK" \
	--action="$LOAD_BALANCER_FIREWALL_ACTION" \
	--direction="$LOAD_BALANCER_FIREWALL_DIRECTION" \
	--source-ranges="$LOAD_BALANCER_FIREWALL_SOURCE_RANGES" \
	--rules="$LOAD_BALANCER_FIREWALL_RULES"


# 4. Set named ports to instance group
gcloud compute instance-groups managed set-named-ports "$LOAD_BALANCER_GROUP" \
	--named-port "$LOAD_BALANCER_NAMED_PORTS" \
	--zone="$ZONE"


# 5. Create health check for load balancer
gcloud compute http-health-checks create "$LOAD_BALANCER_HEALTH_CHECK" \
	--port "$LOAD_BALANCER_HEALTH_CHECK_PORT"


# 6. Create backend service
gcloud compute backend-services create "$LOAD_BALANCER_BACKEND_SERVICE" \
	--protocol="$LOAD_BALANCER_BACKEND_SERVICE_PROTOCOL" \
	--port-name="$LOAD_BALANCER_BACKEND_SERVICE_PORT_NAME" \
	--health-checks="$LOAD_BALANCER_HEALTH_CHECK" \
	--global


# 7. Add backend service
gcloud compute backend-services add-backend "$LOAD_BALANCER_BACKEND_SERVICE" \
	--instance-group="$LOAD_BALANCER_GROUP" \
	--instance-group-zone="$ZONE" \
	--global


# 8. Create URL map route incoming request to default backend service
gcloud compute url-maps create "$LOAD_BALANCER_URL_MAP" \
	--default-service "$LOAD_BALANCER_BACKEND_SERVICE"


# 9. Create target http proxy
gcloud compute target-http-proxies create "$LOAD_BALANCER_PROXY" \
	--url-map "$LOAD_BALANCER_URL_MAP"


# 10. Create global forwarding rule to route incoming request to proxy
gcloud compute forwarding-rules create "$LOAD_BALANCER_FORWARDING_RULE" \
	--global \
	--target-http-proxy="$LOAD_BALANCER_PROXY" \
	--ports="$LOAD_BALANCER_PORT"
