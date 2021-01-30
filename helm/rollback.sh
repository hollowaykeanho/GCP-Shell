#!/bin/bash

NAMESPACE="cd"


# rollback a particular faulty setup
helm rollback "$NAMESPACE"
