#!/bin/bash

# create cluster-admin role in k8n cluster
NAME="user-admin-binding"
EMAIL="student-02-4f4a027c3a41@qwiklabs.net"
kubectl create clusterrolebinding "$NAME" \
	--clusterrole=cluster-admin \
	--user="$EMAIL"




# create cluster-admin role in k8n cluster using service account
NAME="jenkins-deploy"
ACCOUNT="default:cd-jenkins"
kubectl create clusterrolebinding "$NAME" \
	--clusterrole=cluster-admin \
	--serviceaccount="$ACCOUNT"
