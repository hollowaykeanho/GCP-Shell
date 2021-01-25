#!/bin/bash


# list all subnets across all networks, sorted by network
gcloud compute networks subnets list --sort-by=NETWORK
