#!/bin/bash

BUCKET="gs://my-own-bucket-1231123"
USER="AllUsers"
PERMISSION="R"


# Change permission for all users
gsutil acl ch -u "$USER":"$PERMISSION" "$BUCKET"/ada.jpg
