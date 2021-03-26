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




# Task 1 - create service account
export SVC_ACC="my-prod-svc"
gcloud iam service-accounts create "$SVC_ACC" --display-name "$SVC_ACC"
gcloud projects add-iam-policy-binding "$PROJECT" \
	--member=serviceAccount:"${SVC_ACC}@${PROJECT}.iam.gserviceaccount.com" \
	--role=roles/bigquery.admin
gcloud projects add-iam-policy-binding "$PROJECT" \
	--member=serviceAccount:"${SVC_ACC}@${PROJECT}.iam.gserviceaccount.com" \
	--role=roles/storage.admin




# Task 2 - create keyfile
gcloud iam service-accounts keys create key.json \
	--iam-account="${SVC_ACC}@${PROJECT}.iam.gserviceaccount.com"
export GOOGLE_APPLICATION_CREDENTIALS=key.json




# Task 3 & 4 - Modify python file
gsutil cp "gs://$PROJECT/analyze-images.py" .
## edit the python script based on documentations
## perform according to the instructions. APIs do change from time to time.
## Uncomment BigQuery once you're completed with the unit testing.




# Task 5 - Run it and Check Big Query
export BUCKET="$PROJECT"
python analyze-images.py "$PROJECT" "$BUCKET"
## Once done, query the BigQuery:
##   SELECT locale,COUNT(locale) as lcount
##   FROM image_classification_dataset.image_text_detail
##   GROUP BY locale
##   ORDER BY lcount DESC
