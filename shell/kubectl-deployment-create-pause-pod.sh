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

CONTAINER="overprovisioning"
NAMESPACE="kube-system"
CONTAINER_IMAGE="k8s.gcr.io/pause"
PRIORITY_CLASS_NAME="overprovisioning"
POD_CPU="1"
POD_MEM="4Gi"




# 2. Create K8n's deployment
cat << EOF > kubectl apply -f -
apiVersion: scheduling.k8s.io/v1beta1
kind: PriorityClass
metadata:
  name: $PRIORITY_CLASS_NAME
value: -1
globalDefault: false
description: "Priority class used by overprovisioning."
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: $CONTAINER
  namespace: $NAMESPACE
spec:
  replicas: 1
  selector:
    matchLabels:
      run: $CONTAINER
  template:
    metadata:
      labels:
        run: $CONTAINER
    spec:
      priorityClassName: $PRIORITY_CLASS_NAME
      containers:
      - name: $CONTAINER
        image: $CONTAINER_IMAGE
        resources:
          requests:
            cpu: $POD_CPU
            memory: $POD_MEM
EOF
