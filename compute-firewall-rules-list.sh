#!/bin/bash


# list all firewall rules sorted by network
gcloud compute firewall-rules list --sort-by=NETWORK
