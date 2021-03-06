#!/bin/sh

# Merge all Database Scripts into one
cat ./kubectl/mysql/database.sql ./src/main/resources/db/schema.sql ./src/main/resources/db/data.sql > ./kubectl/mysql/db.sql

# Config Map for Data
kubectl create configmap mysql-initdb-config --from-file=./kubectl/mysql/db.sql

# Secrets
kubectl create -f ./kubectl/mysql/mysql-secret.yaml

# Persistent Volume Claims
kubectl create -f ./kubectl/mysql/mysql-persistent-volume-claim.yaml

# Service
kubectl create -f ./kubectl/mysql/mysql-service.yaml

# Deployment
kubectl create -f ./kubectl/mysql/mysql-deployment.yaml