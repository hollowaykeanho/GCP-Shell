#!/bin/bash

# WARNING: this will delete everything to a clean slate


# 1. stop all containers
docker stop "$(docker ps -q)"


# 2. remove all containers
docker rm "$(docker ps -aq)"


# 3. remove images
docker images
docker rmi "$(docker images -aq)"
docker images
## if there are any remaining images, remove them one by one using the
## following command:
## docker rmi "$THE_IMAGE_ID"
