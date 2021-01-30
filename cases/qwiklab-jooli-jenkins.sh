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




# gcloud login
gcloud auth list

## config workspace
export REGION="us-east1"
export ZONE="${REGION}-b"
gcloud config set compute/region "$REGION"
gcloud config set compute/zone "$ZONE"




# provided parameters
export NETWORK="kraken-vpc"
export CLUSTER="jenkins-cd"
export PROJECT="$(gcloud config get-value project)"
gcloud source repos clone sample-app
cd ./sample-app




# source current k8s cluster
gcloud container clusters get-credentials jenkins-cd --zone "$ZONE"
kubectl cluster-info




# create namespaces per architecture
kubectl create ns production
kubectl create ns development
kubectl apply -f k8s/production -n production
kubectl apply -f k8s/canary -n production
kubectl apply -f k8s/services -n production
kubectl apply -f k8s/dev -n development




# helm list out all releases and get the jenkins cd
helm ls
export RELEASE="cd"




# helm uninstall existing unconfigured jenkins
helm uninstall "$RELEASE"




# install jenkin with helm so that we can configure simultenously
helm repo add jenkins https://charts.jenkins.io
helm repo update
export VALUES_FILE="jenkins.yaml"
export SERVICE_ACCOUNT="cd-jenkins"
cat > "$VALUES_FILE" << EOF
master:
  installPlugins:
    - kubernetes:latest
    - workflow-job:latest
    - workflow-aggregator:latest
    - credentials-binding:latest
    - git:latest
    - google-oauth-plugin:latest
    - google-source-plugin:latest
    - google-kubernetes-engine:latest
    - google-storage-plugin:latest
  resources:
    requests:
      cpu: "50m"
      memory: "1024Mi"
    limits:
      cpu: "1"
      memory: "3500Mi"
  javaOpts: "-Xms3500m -Xmx3500m"
  serviceType: ClusterIP
agent:
  resources:
    request:
      cpu: "500m"
      memory: "256Mi"
    limits:
      cpu: "1"
      memory: "512Mi"
persistence:
  size: 100Gi
serviceAccount:
  name: ${SERVICE_ACCOUNT}
EOF
helm install "$RELEASE" jenkins/jenkins -f "$VALUES_FILE" --version 1.2.2 --wait
kubectl get pods | grep "$RELEASE"
rm "$VALUES_FILE"




# get pod name and port-forward to Jenkin UI
export POD_NAME=$(kubectl get pods --namespace default \
	-l "app.kubernetes.io/component=jenkins-master" \
	-l "app.kubernetes.io/instance=cd" \
	-o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $POD_NAME 8080:8080 >> /dev/null &
kubectl get svc




# get default jenkin admin password
printf $(kubectl get secret "$SERVICE_ACCOUNT" \
		-o jsonpath="{.data.jenkins-admin-password}" \
	| base64 --decode);echo
## configure multi-branch pipelines in Jenkins




# [OPTIONAL] get external IP to view output
kubectl get service gceme-frontend -n production
