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




# upload by gsutil
gsutil cp ada.jpg "$BUCKET"/.




# upload by REST
OAUTH2_TOKEN="access-token" # obtain from credentials or OAUTH2 login
OBJECT="/home/gcpstaging25084_student/demo-image.png"
OBJECT_CONTENT_TYPE="image/png"
API="https://www.googleapis.com/upload/storage/v1/b"
TARGET_FILENAME="demo-image"

curl --request POST \
	--data-binary @"$OBJECT" \
	--header "Authorization: Bearer $OAUTH2_TOKEN" \
	--header "Content-Type: $OBJECT_CONTENT_TYPE" \
	"${API}/${BUCKET}/o?uploadType=media&name=${TARGET_FILENAME}"
