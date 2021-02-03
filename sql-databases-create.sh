#!/bin/bash

SQL="me-sql"
DATABASE="wordpress"


## create database inside SQL instance
gcloud sql databases create "$DATABASE" --instance "$SQL"
