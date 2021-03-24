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





## config workspace
export REGION="us-central1"
export ZONE="${REGION}-a"




# create clusters
export CLUSTER="onlineboutique-cluster"
export CLUSTER_MACHINE_TYPE="n1-standard-2"
export CLUSTER_NODES="2"
gcloud container clusters create "$CLUSTER" \
	--zone "$ZONE" \
	--machine-type "$CLUSTER_MACHINE_TYPE" \
	--num-nodes "$CLUSTER_NODES"




# create namespaces
export DEV_NAMESPACE="dev"
export PROD_NAMESPACE="prod"
kubectl create namespace "$DEV_NAMESPACE"
kubectl create namespace "$PROD_NAMESPACE"




# get deployments
git clone https://github.com/GoogleCloudPlatform/microservices-demo.git
cd microservices-demo
kubectl apply -f ./release/kubernetes-manifests.yaml \
	--namespace "$DEV_NAMESPACE"




# Observe memory and cpu requests and allocations and determine a feasible
# CPU + Memory limits for new pool
kubectl get svc -w --namespace "$DEV_NAMESPACE"




# Create new optimized node pools
export OPTIMIZED_POOL="optimized-pool"
export NEW_CLUSTER_MACHINE_TYPE="custom-2-3584"
gcloud container node-pools create "$OPTIMIZED_POOL" \
	--zone "$ZONE" \
	--num-nodes "$CLUSTER_NODES" \
	--cluster "$CLUSTER" \
	--machine-type "$NEW_CLUSTER_MACHINE_TYPE"

## wait for node-pools completion




# Migrate nodes to new pools
export POOL="default-pool" ## find out from dashboard
export NODES="$(kubectl get nodes -l cloud.google.com/gke-nodepool="$POOL" \
	-o=name)"


## Cordon all nodes
for i in $NODES; do
	kubectl cordon "$i"
done


## drain all nodes to new pool
for i in $NODES; do
	kubectl drain --force \
		--ignore-daemonsets \
		--delete-local-data \
		--grace-period=10 \
		"$i"
done


## check all pods are running at the right location. DO NOT PROCEED UNTIL DONE!
kubectl get pods -o=wide --namespace "$DEV_NAMESPACE"


## delete the retired pool
gcloud container node-pools delete "$POOL" \
	--cluster "$CLUSTER" \
	--zone "$ZONE"




# Apply pod distruption budget
export PDB="onlineboutique-frontend-pdb"
export MIN_AVAILABLE="1"
export APP="frontend"
cat << EOF | kubectl apply -f -
apiVersion: policy/v1beta1
kind: PodDisruptionBudget
metadata:
  name: $PDB
  namespace: $DEV_NAMESPACE
spec:
  minAvailable: $MIN_AVAILABLE
  selector:
    matchLabels:
      app: $APP
EOF




# apply team update
export DEPLOYMENT="frontend"
kubectl edit deployment "$DEPLOYMENT" --namespace "$DEV_NAMESPACE"
## EDIT frontend deployment:
##   1) image ->: gcr.io/qwiklabs-resources/onlineboutique-frontend:v2.1
##   2) imagePullPolicy -> Always




# apply horizontal scaling
export CPU_PERCENT_TRIGGER="50"
export MIN_PODS="1"
export MAX_PODS="13"
kubectl autoscale deployment "$DEPLOYMENT" \
	--namespace "$DEV_NAMESPACE" \
	--cpu-percent="$CPU_PERCENT_TRIGGER" \
	--min="$MIN_PODS" \
	--max="$MAX_PODS"




# apply nodes auto provisioning
export MIN_NODES="1"
export MAX_NODES="6"
gcloud container clusters update "$CLUSTER" \
	--zone "$ZONE" \
	--enable-autoscaling \
	--min-nodes "$MIN_NODES" \
	--max-nodes "$MAX_NODES"




# test out overloading
kubectl exec $(kubectl get pod --namespace="$DEV_NAMESPACE" \
	| grep 'loadgenerator' \
	| cut -f1 -d ' ') -it \
	--namespace="$DEV_NAMESPACE" \
	-- bash -c "export USERS=8000; sh ./loadgen.sh"




# apply horizontal scaling to recommendation service
export DEPLOYMENT="recommendationservice"
export CPU_PERCENT_TRIGGER="50"
export MIN_PODS="1"
export MAX_PODS="5"
kubectl autoscale deployment "$DEPLOYMENT" \
	--namespace "$DEV_NAMESPACE" \
	--cpu-percent="$CPU_PERCENT_TRIGGER" \
	--min="$MIN_PODS" \
	--max="$MAX_PODS"




# apply node auto provisioning
MIN_CPU="1"
MIN_MEMORY="3"
MAX_CPU="5"
MAX_MEMORY="15"
gcloud container clusters update "$CLUSTER" \
	--zone "$ZONE"
	--enable-autoprovisioning \
	--min-cpu "$MIN_CPU" \
	--min-memory "$MIN_MEMORY" \
	--max-cpu "$MAX_CPU" \
	--max-memory "$MAX_MEMORY"
