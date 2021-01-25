#!/bin/bash

INSTANCE="qwiklabs-demo"
USER="root"


# connect to managed SQL instances
gcloud sql connect "$INSTANCE" --user="$USER"
