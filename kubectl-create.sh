#!/bin/bash

PROJECT="qwiklabs-gcp-02-803093896dfe"


# create based on config on the fly
cat << EOF | kubectl create -f -
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: "gcr.io/${PROJECT}/nginx:latest"
    ports:
    - containerPort: 80
EOF
