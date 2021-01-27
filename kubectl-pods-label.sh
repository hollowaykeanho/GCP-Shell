#!/bin/bash

POD="secure-monolith"
LABEL="secure=enabled"


# label a pod
kubectl label pods "$POD" "$LABEL"
