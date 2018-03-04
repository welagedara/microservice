#!/bin/sh

# This version uses a Config Map to initialize the Database. Config Maps can only hold upto 1MB of Data( Confirm this).

# Merge all Database Scripts into one
cat ./helm/mysql/database.sql ./src/main/resources/db/schema.sql ./src/main/resources/db/data.sql > ./helm/mysql/db.sql

helm install --name db ./helm/mysql/