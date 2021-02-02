#!/bin/bash

CONFIG_FILE="./policy.yaml"


# import the binary authorization config file
gcloud beta container binauthz policy import "$CONFIG_FILE"
