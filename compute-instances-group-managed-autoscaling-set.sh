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

GROUP="instance-group-1"
PROJECT="qwiklabs-gcp-02-2defea3466d7"
ZONE="us-central1-a"
COOLDOWN="45"
MAX_REPLICAS="5"
MIN_REPLICAS="1"
TARGET_CPU_USE="0.8"
MODE="on"




# set managed instance groups (Google Compute Engine)
gcloud beta compute instance-groups managed set-autoscaling "$GROUP" \
	--zone "$ZONE" \
	--cool-down-period "$COOLDOWN" \
	--min-num-replicas "$MIN_REPLICAS" \
	--max-num-replicas "$MAX_REPLICAS" \
	--target-cpu-utilization "$TARGET_CPU_USE" \
	--mode "$MODE"
