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

# create bucket for storage
export REGION="us-central1-a"
export BUCKET="gs://project-name-here-1231231"
export BUCKET_CLASS="STANDARD"
export BUCKET_LOCATION="US-CENTRAL1"
export PROJECT_ID="$DEVSHELL_PROJECT_ID"
gsutil mb "$BUCKET" -c "$BUCKET_CLASS" -l "$BUCKET_LOCATION" -p "$PROJECT_ID"




# check python3 usage
python3 --version




# install pip3
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py




# install vitualenv
pip3 install --upgrade virtualenv




# setup virtualenv
virtualenv -p python3.7 env
source env/bin/activate




# install Apache Beam
pip install apache-beam[gcp]




# run wordcount analysis
python -m apache_beam.examples.wordcount --output OUTPUT_FILE




# run Apache Beam Analysis
python -m apache_beam.examples.wordcount --project "$DEVSHELL_PROJECT_ID" \
  --runner DataflowRunner \
  --staging_location "$BUCKET"/staging \
  --temp_location "$BUCKET"/temp \
  --output "$BUCKET"/results/output \
  --region "$REGION"
