#!/bin/bash

export NAME="sample-app"
export PROJECT=$(gcloud info --format='value(config.project)')


# 1. create source repos
gcloud source repos create "$NAME"


# 2. initialize git repo
cd ./"$NAME"
git config credential.helper gcloud.sh
git remote add origin https://source.developers.google.com/p/$PROJECT/r/$NAME
git push origin master
