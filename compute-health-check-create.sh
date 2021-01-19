#!/bin/bash

NAME="basic-check"


# create health check
gcloud compute http-health-checks create "$NAME"
