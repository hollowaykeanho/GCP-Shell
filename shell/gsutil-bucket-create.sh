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

BUCKET="gs://my-own-bucket-1231123"
CLASS="STANDARD" # See: https://cloud.google.com/storage/docs/storage-classes
LOCATION="ASIA" # See: https://cloud.google.com/storage/docs/locations
PROJECT_ID="Your-Project-ID"
#RETENTION="1y"




# create by gsutils
# gsutil mb gs://YOUR-NAME-HERE
gsutil mb "$BUCKET" -c "$CLASS" -l "$LOCATION" -p "$PROJECT_ID" #--retention "$RETENTION"




# create by REST
OAUTH2_TOKEN="access-token" # obtain from credentials or OAUTH2 login
PROJECT_ID="$(gcloud config get-value project)" # or just fill in yourself

curl --request POST \
	--header "Authorization: Bearer $OAUTH2_TOKEN" \
	--header "Content-Type: application/json" \
	--data-binary @- \
	"https://www.googleapis.com/storage/v1/b?project=$PROJECT_ID" << EOF
   "name": "${BUCKET#*//}",
   "location": "$LOCATION",
   "storageClass": "$CLASS"
EOF
