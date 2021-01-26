#!/bin/bash

SQL="griffin-dev-db"
SQL_AVAILABILITY="regional"
SQL_VERSION="MYSQL_8_0"
SQL_TIER="db-n1-standard-1"


# create cloud SQL instance (4 spaces in front is needed as we are entering
# root password here to prevent being captured by history log)
    gcloud sql instances create "$SQL" \
	--availability-type="$SQL_AVAILABILITY" \
	--backup \
	--database-version "$SQL_VERSION" \
	--tier "$SQL_TIER" \
	--root-password "myR0()Ttesting123" \
	--enable-bin-log \
	--region "$REGION"
