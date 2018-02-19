#!/bin/sh

IMAGE_NAME=com.example/microservice
TARGET_IMAGE_NAME=${1:-pubuduwelagedara/microservice}

# TODO: 2/17/19 Configure this to use commit id
# tag=$(git rev-parse --short HEAD)
tag=latest

# Delete any stray images
docker rmi $IMAGE_NAME:$tag 2>/dev/null
docker rmi $TARGET_IMAGE_NAME 2>/dev/null

./gradlew build -Ptag=$tag docker

# push the image to Docker Hub
docker tag $IMAGE_NAME:$tag $TARGET_IMAGE_NAME
docker push $TARGET_IMAGE_NAME

# Now deploying the App

# TODO: 2/17/19 Below line will work with Mac. Check compatibility with Linux
perl -pi -w -e 's/IMAGE_NAME/$ENV{'TARGET_IMAGE_NAME'}/g;' ./kubectl/microservice/microservice-deployment.yaml

# Service
kubectl create -f ./kubectl/microservice/microservice-service.yaml

# Deployment
kubectl create -f ./kubectl/microservice/microservice-deployment.yaml