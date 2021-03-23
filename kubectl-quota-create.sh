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

PODS_LIMIT=6
LOAD_BALANCERS_LIMIT=1
CPU_LIMIT=4
MEMORY_LIMIT="12Gi"
CPU_REQUEST_LIMIT="2"
MEMORY_REQUEST_LIMIT="8Gi"


# create resource quota
cat << EOF | kubectl apply -f -
apiVersion: v1
kind: ResourceQuota
metadata:
  name: test-quota
  namespace: team-a
spec:
  hard:
    count/pods: "$PODS_LIMIT"
    count/services.loadbalancers: "$LOAD_BALANACER_LIMIT"
    limits.cpu: "$CPU_LIMIT"
    limits.memory: "$MEMORY_LIMIT"
    requests.cpu: "$CPU_REQUEST_LIMIT"
    request.memory: "$MEMORY_REQUEST_LIMIT"
EOF
