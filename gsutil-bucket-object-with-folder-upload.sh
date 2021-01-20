#!/bin/bash

BUCKET="gs://my-own-bucket-1231123"


# create bucket directory (image-folder)
gsutil cp -r "$BUCKET"/ada.jpg "$BUCKET"/image-folder/.
