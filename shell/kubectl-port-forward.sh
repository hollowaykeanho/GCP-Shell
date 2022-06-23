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

LOCAL_PORT="8080"
REMOTE_PORT="9000"




# Method A) 1. get spin deck info from pods
SPIN_DECK="$(kubectl get pods --namespace default \
	-l "cluster=spin-deck" \
	-o jsonpath="{.items[0].metadata.name})"

## Method A) 2. port-forward from remote:9000 to local:8080
kubectl port-forward --namespace default "$SPIN_DECK" \
	"${LOCAL_PORT}:{$REMOTE_PORT}" &> /dev/null




# Method B) 1. get pod name
CLUSTER_NAME="jenkins-master"
POD_NAME=$(kubectl get pods --namespace default \
	-l "app.kubernetes.io/component=${CLUSTER_NAME}" \
	-l "app.kubernetes.io/instance=cd" \
	-o jsonpath="{.items[0].metadata.name}")

## Method B) 2. port-forward
kubectl port-forward "$POD_NAME" "${LOCAL_PORT}:${REMOTE_PORT}" &> /dev/null
