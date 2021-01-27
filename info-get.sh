#!/bin/bash


# get project info
export PROJECT="$(gcloud info --format 'value(config.project)')"
