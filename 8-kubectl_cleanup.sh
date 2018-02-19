#!/bin/sh

IMAGE_NAME=com.example/microservice
TARGET_IMAGE_NAME=pubuduwelagedara/microservice

# TODO: 2/17/19 Configure this to use commit id
# tag=$(git rev-parse --short HEAD)
tag=latest

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

# Now the microservice

# Service
kubectl delete -f ./kubectl/microservice/microservice-service.yaml

# Deployment
kubectl delete -f ./kubectl/microservice/microservice-deployment.yaml

# Delete any stray images
docker rmi $IMAGE_NAME:$tag 2>/dev/null
docker rmi $TARGET_IMAGE_NAME 2>/dev/null