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

export REGION="us-central1"
export ZONE="us-central1-a"
export PROJECT="$(gcloud config get-value project)"
export API_KEY="AIzaSyB5ukf60v1kWSJ7yLXb7DTRKzJzSX_5Os4" # get from IAM




# Task 1
## get schema
gsutil cp gs://cloud-training/gsp323/lab.schema .
cat lab.schema # for later BigQuery population usage

## create BigQuery data entry

## create bucket
gsutil mb "gs://{$PROJECT}" -c "STANDARD" -l "US-CENTRAL1"




# Task 2
## create cluster
export CLUSTER="dataproc-cluster-01"
export CLUSTER_WORKER_DISK_SIZE="500"
gcloud dataproc clusters create "$CLUSTER" \
	--zone "$ZONE" \
	--worker-boot-disk-size "$CLUSTER_WORKER_DISK_SIZE"


## SSH into the cluster (inside master instance)
### > hdfs dfs -cp gs://cloud-training/gsp323/data.txt /data.txt
### exit the SSH terminal


## submit job to cluster




# Task 3
## Use GUI




# Task 4
## AI - speech
export RESULT_FILE="task4-gcs.result"
export FILE_URI="gs://cloud-training/gsp323/task4.flac"
curl --silent --request POST \
	--header "Content-Type: application/json" \
	--data-binary @- \
	"https://speech.googleapis.com/v1/speech:recognize?key=${API_KEY}" \
	> "$RESULT_FILE" << EOF
{
  "config": {
      "encoding":"FLAC",
      "languageCode": "en-US"
  },
  "audio": {
      "uri":"$FILE_URI"
  }
}
EOF

### copy into bucket
gsutil -h "Content-Type:application/json" \
	cp "$RESULT_FILE" "gs://${PROJECT}-marking/${RESULT_FILE}"
cloudshell download "$RESULT_FILE"


## AI - NatLang
export RESULT_FILE="task4-cnl.result"
export CONTENT="Old Norse texts portray Odin as one-eyed and long-bearded, frequently wielding a spear named Gungnir and wearing a cloak and a broad hat."
gcloud ml language analyze-entities --content="$CONTENT" > "$RESULT_FILE"

### copy into bucket
gsutil -h "Content-Type:application/json" \
	cp "$RESULT_FILE" "gs://${PROJECT}-marking/${RESULT_FILE}"
cloudshell download "$RESULT_FILE"


## AI - Video
### Create current user service account key file and upload to gcloud
gcloud auth activate-service-account --key-file key.json
export TOKEN=$(gcloud auth print-access-token)

### process the video
export RESULT_FILE="task4-cvi.result"
export FILE_URI="gs://spls/gsp154/video/train.mp4"
curl --silent --header "Content-Type: application/json" \
	--header "Authorization: Bearer $TOKEN" \
	--data-binary @- \
	"https://videointelligence.googleapis.com/v1/videos:annotate" \
	> "$RESULT_FILE" << EOF
{
   "inputUri":"${FILE_URI}",
   "features": [
       "LABEL_DETECTION"
   ]
}
EOF

### extract video results
OPERATION="$(cat $RESULT_FILE | grep name)"
OPERATION="${OPERATION#*: \"}"
OPERATION="${OPERATION%\"*}"
curl --silent \
	--header "Content-Type: application/json" \
	--header "Authorization: Bearer $TOKEN" \
	"https://videointelligence.googleapis.com/v1/${OPERATION}" \
	> "$RESULT_FILE"

### copy into bucket
gsutil -h "Content-Type:application/json" \
	cp "$RESULT_FILE" "gs://${PROJECT}-marking/${RESULT_FILE}"
cloudshell download "$RESULT_FILE"
