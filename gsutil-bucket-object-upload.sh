#!/bin/bash

BUCKET="gs://my-own-bucket-1231123"


# upload a file to Google Storage bucket
gsutil cp ada.jpg "$BUCKET"/.
