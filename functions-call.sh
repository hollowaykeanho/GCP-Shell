#!/bin/bash

NAME="helloWorld"


# 1. create your data for calls
DATA="{ \"data\": \"$(printf 'Hello World!'| base64)\" }"


# 2. call the function
gcloud functions call "$NAME" --data "$DATA"
