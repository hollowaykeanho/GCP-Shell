#!/bin/bash

BUCKET="gs://my-own-bucket-1231123"


# list contents inside a bucket of its directory
gsutil ls "$BUCKET"/image-folder

# list details
gsutil ls -la "$BUCKET"/image-folder
