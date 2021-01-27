#!/bin/bash

POD="monolith"


# read logs by streaming from a pod
kubectl logs -f "$POD"
# press CTRL+C to stop
