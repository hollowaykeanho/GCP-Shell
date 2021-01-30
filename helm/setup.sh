#!/bin/bash

VERSION="v3.1.1"
OS="linux"
CPU="amd64"


# download helm
wget "https://get.helm.sh/helm-${VERSION}-${OS}-${CPU}.tar.gz"


# unpack the tarball
tar zxfv ./"helm-${VERSION}-${OS}-${CPU}.tar.gz"


# copy the binary out
cp linux-amd64/helm .


# add helm repo
./helm repo add stable https://charts.helm.sh/stable
./helm repo update
