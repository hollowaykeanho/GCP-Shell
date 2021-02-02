#!/bin/bash

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
