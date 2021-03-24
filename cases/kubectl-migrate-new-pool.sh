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

ZONE="us-central1-a"
CLUSTER="hello-demo-cluster"
POOL="default-pool"
NODES="$(kubectl get nodes -l cloud.google.com/gke-nodepool="$POOL" -o=name)"

# create the new optimized pool
## See container-node-pools-create.sh




# cordon the existing pool
for i in $NODES; do
	kubectl cordon "$i"
done




# drain the existing pool
for i in $NODES; do
	kubectl drain --force \
		--ignore-daemonsets \
		--delete-local-data \
		--grace-period=10 \
		"$i"
done




# check all pods are running on new optimized pool
kubectl get pods -o=wide




# delete the retired pool
gcloud container node-pools delete "$POOL" \
	--cluster "$CLUSTER" \
	--zone "$ZONE"
