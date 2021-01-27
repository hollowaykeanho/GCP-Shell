#!/bin/bash

SPIN_URL="https://storage.googleapis.com/spinnaker-artifacts/spin/1.14.0/linux/amd64/spin"


# download spin program
curl -LO "$SPIN_URL"
chmod +x spin
