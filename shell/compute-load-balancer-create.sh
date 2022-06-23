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




# Create custom one-time load balancer
NETWORK_NAME="network-1b-ip-1"
REGION="us-central1"
HEALTH_CHECK="basic-check"

POOL_NAME="www-pool"
POOL_INSTANCES="www1,www2,www3"
POOL_FORWARDING_RULE="www-rule"




# 1. Create static external IP for load balancer
gcloud compute addresses create "$NETWORK_NAME" --region "$REGION"




# 2. Add HTTP health check
gcloud compute http-health-checks create "$HEALTH_CHECK"




# 3. Add target pool
gcloud compute target-pools create "$POOL_NAME" \
	--region "$REGION" \
	--http-health-check "$HEALTH_CHECK"




# 4. Add instances to target pool
gcloud compute target-pools add-instances "$POOL_NAME" \
	--instances "$POOL_INSTANCES"




# 5. Add forwarding rule
gcloud compute forwarding-rules create "$POOL_FORWARDING_RULE" \
	--region "$REGION" \
	--port 80 \
	--address "$NETWORK_NAME" \
	--target-pool "$POOL_NAME"
