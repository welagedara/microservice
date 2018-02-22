#!/bin/sh

IMAGE_NAME=com.example/microservice
TARGET_IMAGE_NAME=${1:-pubuduwelagedara/microservice}
MYSQL_IMAGE_NAME=my-mysql
MYSQL_TARGET_IMAGE_NAME=${1:-pubuduwelagedara/mysql}

# TODO: 2/17/19 Configure this to use commit id
# tag=$(git rev-parse --short HEAD)
tag=latest

# Delete any stray images
docker rmi $IMAGE_NAME:$tag 2>/dev/null
docker rmi $TARGET_IMAGE_NAME 2>/dev/null

# Delete any stray images
docker rmi $MYSQL_IMAGE_NAME:$tag 2>/dev/null
docker rmi $MYSQL_TARGET_IMAGE_NAME 2>/dev/null

helm delete --purge db

helm delete --purge microservice