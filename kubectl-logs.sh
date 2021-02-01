#!/bin/bash




# read logs by streaming from a pod
POD="monolith"
kubectl logs -f "$POD"
# press CTRL+C to stop




# dump specific app
NAME="pod-labeler"
kubectl logs -l app="$NAME"
