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




# configure gcloud
gcloud auth list
export REGION="us-east1"
export ZONE="${REGION}-b"

gcloud config set compute/zone "$ZONE"
gcloud config set compute/region "$REGION"




# Task 1
export BURCKET="kraken-photos-bucket"
gsutil mb "$BUCKET"




# Task 2
export TOPIC="kraken-pubsub"
gcloud pubsub topics create "$TOPIC"




# Task 3
## 1. upload the file into bucket and copy it into gshell


## 2. execute function
NAME="thumbnail"
RUNTIME="nodejs10"
TRIGGER="google.storage.object.finalize"
gcloud functions deploy "$NAME" \
	--runtime "$RUNTIME" \
	--trigger-resource "$BUCKET" \
	--trigger-event "$TRIGGER"
