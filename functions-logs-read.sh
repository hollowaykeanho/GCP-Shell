#!/bin/bash

NAME="helloWorld"


# Read Google Function logs (this command takes 10 mins on first try)
gcloud functions --logs read "$NAME"
