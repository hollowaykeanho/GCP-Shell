#!/bin/bash

PROJECT="$(gcloud config get-value project)"

ATTESTOR="manually-verified"
ATTESTOR_NAME="Manual Attestor"
ATTESTOR_EMAIL="$(gcloud config get-value core/account)"

NOTE_ID="Human-Attestor-Note"
NOTE_DESC="Human Attestation Note Demo"

NOTE_PAYLOAD_FILE="note_payload.json"
IAM_REQUEST_FILE="iam_request.json"

GCLOUD_BETA_URL="https://containeranalysis.googleapis.com/v1beta1"

PGP_PUB_KEY="generated-key.pgp"



# 1. install dependencies
sudo apt install gpg2 curl rng-tools -y




# 2. create an attestation note
cat > "$NOTE_PAYLOAD_FILE" << EOF
{
	"name": "projects/${PROJECT_ID}/notes/${NOTE_ID}",
	"attestation_authority": {
		"hint": {
			"human_readable_name": "${NOTE_DESC}"
		}
	}
}
EOF
curl -X POST \
	-H "Content-Type: application/json" \
	-H "Authorization: Bearer $(gcloud auth print-access-token)" \
	--data-binary @"$NOTE_PAYLOAD_PATH" \
	"${GCLOUD_BETA_URL}/projects/${PROJECT}/notes/?noteId=${NOTE_ID}"




# 3. create PGP signing key (optional if you have it)
sudo rngd -r /dev/urandom
gpg --quick-generate-key --yes "${ATTESTOR_EMAIL}"
gpg --armor --export "${ATTESTOR_EMAIL}" > "${PGP_PUB_KEY}"

## register key
gcloud --project="${PROJECT}" \
	beta container binauthz attestors create "${ATTESTOR}" \
	--attestation-authority-note="${NOTE_ID}" \
	--attestation-authority-note-project="${PROJECT}"
