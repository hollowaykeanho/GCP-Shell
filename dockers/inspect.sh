#!/bin/bash

ID="1917b8a35877"
FORMAT="{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}"


# docker inspect ID
docker inspect "$ID"


# docker inspect with format
docker inspect --format="$FORMAT" "$ID"
