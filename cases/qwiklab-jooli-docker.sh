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




# auth gcloud
gcloud auth list

## setup default config
export STANDARD_MACHINE_TYPE="n1-standard-1"
export REGION="us-east1"
export ZONE="${REGION}-b"
gcloud config set compute/zone "$ZONE"
gcloud config set compute/region "$REGION"




# create docker image
source <(gsutil cat gs://cloud-training/gsp318/marking/setup_marking.sh)
export PROJECT="$(gcloud config get-value project)"
export PROJECT_NAME="valkyrie-app"
export PROJECT_TAG="v0.0.1"
gcloud source repos clone "$PROJECT_NAME" --project="$PROJECT"

## create Dockerfile
cd "$PROJECT_NAME"
cat > Dockerfile <<EOF
FROM golang:1.10
WORKDIR /go/src/app
COPY source .
RUN go install -v
ENTRYPOINT ["app","-single=true","-port=8080"]
EOF
docker build -t "${PROJECT_NAME}:${PROJECT_TAG}" .
${HOME}/marking/step1.sh




# test docker image
docker run -p 8080:8080 --name "$PROJECT_NAME" -d "${PROJECT_NAME}:${PROJECT_TAG}"
${HOME}/marking/step2.sh




# push to container
export PROJECT_URL="gcr.io/${PROJECT}/${PROJECT_NAME}:${PROJECT_TAG}"
docker tag "${PROJECT_NAME}:${PROJECT_TAG}" "$PROJECT_URL"
docker push "$PROJECT_URL"




# create and expose k8n
sed -i "s/IMAGE_HERE/${PROJECT_URL}/g" ./k8s/deployment.yaml
gcloud container clusters get-credentials valkyrie-dev --region "$REGION"
for i in k8s/*; do kubectl create -f "$i"; done




# update deployment with scale and new codes
gcloud edit deployment valkyrie-dev
## update replicas: 1 --> replicas: 3

## merge kurt-dev to master
git merge origin/kurt-dev

## update docker image
export PROJECT_TAG="v0.0.2"
export PROJECT_URL="gcr.io/${PROJECT}/${PROJECT_NAME}:${PROJECT_TAG}"
docker build -t "${PROJECT_NAME}:${PROJECT_TAG}" .
docker tag "${PROJECT_NAME}:${PROJECT_TAG}" "$PROJECT_URL"
docker images
docker push "$PROJECT_URL"
gcloud edit deployment valkyrie-dev
## update image URL from v0.0.1 --> v0.0.2




# create Jenkins pipeline
CLUSTER="cd-jenkins"
DATA=".data.jenkins-admin-password"
kubectl get secret "$CLUSTER" -o jsonpath="$DATA" | base64 --decode
export POD_NAME=$(kubectl get pods --namespace default \
	-l "app.kubernetes.io/component=jenkins-master" \
	-l "app.kubernetes.io/instance=cd" \
	-o jsonpath="{.items[0].metadata.name}")
docker ps &> /dev/null
docker container kill $(docker ps -q) &> /dev/null
kubectl port-forward $POD_NAME 8080:8080 &> /dev/null &

## setup jenkins accordingly using its GUI
