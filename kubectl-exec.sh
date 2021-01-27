#!/bin/bash

POD="monolith"


# execute interactive shell to the pod (DEPRECATED)
kubectl exec "$POD" --stdin --tty -c "$POD" /bin/sh


# directly execute a command
kubectl exec "$POD" --stdin --tty -c "$POD" /bin/sh -- \
	ping -c 3 google.com
