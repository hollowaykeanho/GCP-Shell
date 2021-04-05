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




# create kubernetes cluster
export CLUSTER="echo-cluster"
export ZONE="us-central1-a"
export CLUSTER_MACHINE_TYPE="n1-standard-2"
export CLUSTER_NODES="2"
gcloud container clusters create "$CLUSTER" \
	--zone "$ZONE" \
	--num-nodes "$CLUSTER_NODES" \
	--machine-type "$CLUSTER_MACHINE_TYPE"




# process docker image
export ARTIFACT_PACK="echo-web.tar.gz"
export APP="echo-app"
export APP_VERISON="v1"
export DOCKER_URL="gcr.io/${PROJECT}/${APP}:${APP_VERSION}"
gsutil cp "gs://${PROJECT}/${ARTIFACT_PACK}" .
tar -xvzf "$ARTIFACT_PACK"
cd echo-web
docker build -t "${APP}:${APP_VERSION}" .
docker tag "${APP}:${APP_VERSION}" "$DOCKER_URL"
docker push "$DOCKER_URL"




# deploy using kubectl
export APP_PORT="8000"
export LOAD_BALANCER="echo-web"
export LOAD_BALANCER_PORT="80"
gcloud container clusters get-credentials "$CLUSTER"
kubectl create deployment --image="$DOCKER_URL" --port "$APP_PORT" "$APP"
kubectl expose deployment "$APP" \
	--name "$LOAD_BALANCER" \
	--type LoadBalancer \
	--port "$LOAD_BALANCER_PORT" \
	--target-port "$APP_PORT"




# get service external IP
kubectl get service "$LOAD_BALANCER"
