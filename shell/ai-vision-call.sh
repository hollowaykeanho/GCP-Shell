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

API_KEY="your-api-key" # create one via API & Service > Credentials
IMAGE_URI="gs://qwiklabs-gcp-02-894dc33eec85/sign.jpg"




# call vision API to identify text
curl --silent -request POST \
	--header "Content-Type: application/json" \
	--data-binary @- \
	"https://vision.googleapis.com/v1/images:annotate?key=${API_KEY}" << EOF
{
  "requests": [
      {
        "image": {
          "source": {
              "gcsImageUri": "$IMAGE_URI"
          }
        },
        "features": [
          {
            "type": "TEXT_DETECTION",
            "maxResults": 10
          }
        ]
      }
  ]
}
EOF




# call vision API to identify label
curl --silent -request POST \
	--header "Content-Type: application/json" \
	--data-binary @- \
	"https://vision.googleapis.com/v1/images:annotate?key=${API_KEY}" << EOF
{
  "requests": [
      {
        "image": {
          "source": {
              "gcsImageUri": "$IMAGE_URI"
          }
        },
        "features": [
          {
            "type": "LABEL_DETECTION",
            "maxResults": 10
          }
        ]
      }
  ]
}
EOF




# call vision API to perform web search using image
curl --silent -request POST \
	--header "Content-Type: application/json" \
	--data-binary @- \
	"https://vision.googleapis.com/v1/images:annotate?key=${API_KEY}" << EOF
{
  "requests": [
      {
        "image": {
          "source": {
              "gcsImageUri": "$IMAGE_URI"
          }
        },
        "features": [
          {
            "type": "WEB_DETECTION",
            "maxResults": 10
          }
        ]
      }
  ]
}
EOF




# call vision API to perform face detection
curl --silent -request POST \
	--header "Content-Type: application/json" \
	--data-binary @- \
	"https://vision.googleapis.com/v1/images:annotate?key=${API_KEY}" << EOF
{
  "requests": [
      {
        "image": {
          "source": {
              "gcsImageUri": "$IMAGE_URI"
          }
        },
        "features": [
          {
            "type": "FACE_DETECTION",
            "maxResults": 10,
          }
        ]
      }
  ]
}
EOF




# call vision API to perform landmark detection
curl --silent -request POST \
	--header "Content-Type: application/json" \
	--data-binary @- \
	"https://vision.googleapis.com/v1/images:annotate?key=${API_KEY}" << EOF
{
  "requests": [
      {
        "image": {
          "source": {
              "gcsImageUri": "$IMAGE_URI"
          }
        },
        "features": [
          {
            "type": "LANDMARK_DETECTION",
            "maxResults": 10,
          }
        ]
      }
  ]
}
EOF




# call vision API to perform logo detection
curl --silent -request POST \
	--header "Content-Type: application/json" \
	--data-binary @- \
	"https://vision.googleapis.com/v1/images:annotate?key=${API_KEY}" << EOF
{
  "requests": [
      {
        "image": {
          "source": {
              "gcsImageUri": "$IMAGE_URI"
          }
        },
        "features": [
          {
            "type": "SAFE_SEARCH_DETECTION"
          }
        ]
      }
  ]
}
EOF
