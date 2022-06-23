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

CIPHERTEXT="AFNAER\$T@gehTNESRH#\$YT#@RHAERHAEHAERH" # just example
OUTPUT="1.encrypted"

AUTH_TOKEN="$(gcloud auth application-default print-access-token)"
PROJECT="$(gcloud config get-value project)"
URL="https://cloudkms.googleapis.com/v1/projects/${PROJECT}/locations/global/keyRings/${KEYRING}/cryptoKeys/${KEY}"
KEYRING="test"
KEY="qwiklab"




# decrypt data with kms
curl --header "Authorization:Bearer $AUTH_TOKEN" \
	--header "Content-Type: application/json" \
	--data-binary @- \
	"$URL:decrypt" > "$OUTPUT" << EOF
{
	"ciphertext": "$CIPHERTEXT"
}
EOF




# decode from json and save to file
jq plaintext -r "$OUTPUT" | base64 -d > "${OUTPUT}.tmp"
mv "${OUTPUT}.tmp" "$OUTPUT"
