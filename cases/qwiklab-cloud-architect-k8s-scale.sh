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




# process docker image
export PROJECT="$(gcloud config get-value project)"
export CLUSTER="echo-cluster"
export ZONE="us-central1-a"
export ARTIFACT_PACK="echo-web-v2.tar.gz"
export APP="echo-app"
export APP_VERSION="v2"
export DOCKER_URL="gcr.io/${PROJECT}/${APP}:${APP_VERSION}"
gsutil cp "gs://${PROJECT}/${ARTIFACT_PACK}" .
tar -xvzf "$ARTIFACT_PACK"
docker build -t "${APP}:${APP_VERSION}" .
docker tag "${APP}:${APP_VERSION}" "$DOCKER_URL"
docker push "$DOCKER_URL"
printf "\nversion 2 docker URL is: %s\n" "$DOCKER_URL"




# deploy using kubectl
export DEPLOYMENT="echo-web"
kubectl edit deployment "$DEPLOYMENT"
## edit replica to 2
## edit URL to the value from "$DOCKER_URL" printed above.
## save and exit
kubectl rollout restart deployment "$DEPLOYMENT"




# wait for update to roll out and check the IP
kubectl get service "$DEPLOYMENT"
