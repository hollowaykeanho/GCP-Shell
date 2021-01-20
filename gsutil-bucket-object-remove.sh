#!/bin/bash

BUCKET="gs://my-own-bucket-1231123"


# remove a file from Google Storage bucket
gsutil rm "$BUCKET"/ada.jpg
