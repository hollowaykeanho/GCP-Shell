#!/bin/bash

EMAIL="student-02-4f4a027c3a41@qwiklabs.net"


# create cluster-admin role in k8n cluster
kubectl create clusterrolebinding user-admin-binding \
	--clusterrole=cluster-admin \
	--user="$EMAIL"
