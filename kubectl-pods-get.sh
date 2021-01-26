#!/bin/bash


# get pods information
kubectl get pods -o jsonpath \
	--template='{range .items[*]}{.metadata.name}{"\t"}{"\t"}{.spec.containers[0].image}{"\n"}{end}'
