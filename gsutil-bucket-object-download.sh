#!/bin/bash

BUCKET="gs://my-own-bucket-1231123"


# download a file from Google Storage bucket
gsutil cp -r "$BUCKET"/ada.jpg .
