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

PROJECT="$(gcloud config get-value account)"
ATTESTOR="manually-verified"
ATTESTOR_EMAIL="$(gcloud config get-value core/account)"

IMAGE_PAYLOAD="image-payload.json"
IMAGE_SIGNATURE="image-signature.pgp"
IMAGE_PATH="gcr.io/${PROJECT}/nginx"
IMAGE_DIGEST="$(gcloud container images list-tags \
	--format='get(digest)' \
	"$IMAGE_PATH" \
	| head -1)"

PGP_FINGERPRINT="$(gpg --list-keys ${ATTESTOR_EMAIL} \
	| head -2 \
	| tail -1 \
	| awk '{print $1}')"




# create signature
gcloud beta container binauthz create-signature-payload \
	--artifact-url="${IMAGE_PATH}@${IMAGE_DIGEST}" \
	> "$IMAGE_PAYLOAD"




# sign the payload
gpg --local-user "$ATTESTOR_EMAIL" \
	--armor \
	--output "$IMAGE_SIGNATURE" \
	--sign "$IMAGE_PAYLOAD"




# read the signature
cat "$IMAGE_SIGNATURE"




# attest the image
gcloud beta container binauthz attestations create \
	--artifact-url="${IMAGE_PATH}@${IMAGE_DIGEST}" \
	--attestor="projects/${PROJECT}/attestors/${ATTESTOR}" \
	--signature-file=${IMAGE_SIGNATURE} \
	--public-key-id="${PGP_FINGERPRINT}"
