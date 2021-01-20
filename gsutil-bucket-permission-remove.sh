#!/bin/bash

BUCKET="gs://my-own-bucket-1231123"
USER="AllUsers"


# Change permission for all users
gsutil acl ch -d "$USER" "$BUCKET"/ada.jpg
