#!/bin/bash

export NAME="sample-app"
export PROJECT=$(gcloud info --format='value(config.project)')


# 1. create source repos
gcloud source repos create "$NAME"


# 2. clone the source repo
## See: source-repos-clone.sh


# 3. initialize git repo and proceed like git
cd ./"$NAME"
git config credential.helper gcloud.sh
git remote add origin https://source.developers.google.com/p/$PROJECT/r/$NAME
git push origin master
