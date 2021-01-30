#!/bin/bash

CLUSTER="jenkins-cd"
CONFIG="./jenkins.yaml"
VERSION="2.6.4"


# 1. Install jenkins
helm install "$CLUSTER" \
	-f "$CONFIG" \
	jenkinsci/jenkins \
	--version "$VERSION" \
	--wait
