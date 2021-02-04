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

NAME="app-allow-health-check"
NETWORK="my-internal-app"
DIRECTION="INGRESS"
ACTION="ALLOW"
RULES="tcp"
SOURCE_RANGES="130.211.0.0/22,35.191.0.0/16"
PRIORITY="1000"
TARGET_TAGS="lb-backend"
PROJECT="qwiklabs-gcp-00-1cc9fe3b3f13"  # optional argument




# create new firewall rule for http health check
gcloud compute firewall-rules create "$NAME" \
	--network "$NETWORK" \
	--direction "$DIRECTION" \
	--action "$ACTION" \
	--rules "$RULES" \
	--source-ranges "$SOURCE_RANGES" \
	--priority "$PRIORITY" \
	--target-tags "$TARGET_TAGS" \
	--project "$PROJECT"
