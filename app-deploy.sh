#!/bin/bash

CONFIG_FILE="./app.yaml"


# edit the app.yaml file
cat > "app.yaml" << EOF
runtime: python37
EOF


# deploy Google App
gcloud app deploy
