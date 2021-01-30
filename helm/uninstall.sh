#!/bin/bash


# 1. list all deployed releases
# (see: helm/releases-list.sh). Example returning values:
## NAME             VERSION   UPDATED                   STATUS    CHART
## smiling-penguin  1         Wed Sep 28 12:59:46 2016  DEPLOYED  mysql-0.1.0

# 2. uninstall the release
helm uninstall smiling-penguin
