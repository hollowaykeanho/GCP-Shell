#!/bin/bash

KEY="./credentials.json"


# activate a service account inside the VM
gcloud auth activate-service-account --key-file "$KEY"
