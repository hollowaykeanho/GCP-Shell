#!/bin/bash

CONFIG_FILE="./policy.yaml"


# export current binary authorization file
gcloud beta container binauthz policy export > "$CONFIG_FILE"
