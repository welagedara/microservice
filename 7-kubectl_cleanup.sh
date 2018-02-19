#!/bin/sh

# Service
kubectl delete -f ./kubectl/mysql/mysql-service.yaml

# Deployment
kubectl delete -f ./kubectl/mysql/mysql-deployment.yaml

# Config Map
kubectl delete configmap mysql-initdb-config

# Secrets
kubectl delete -f ./kubectl/mysql/mysql-secret.yaml

# Persistent Volume Claims
kubectl delete -f ./kubectl/mysql/mysql-persistent-volume-claim.yaml
