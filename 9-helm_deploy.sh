#!/bin/sh

# This version uses a Config Map to initialize the Database. Config Maps can only hold upto 1MB of Data( Confirm this).

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
docker tag $IMAGE_NAME:$tag $TARGET_IMAGE_NAME:$tag
docker push $TARGET_IMAGE_NAME

# Merge all Database Scripts into one
cat ./helm/mysql/database.sql ./src/main/resources/db/schema.sql ./src/main/resources/db/data.sql > ./helm/mysql/db.sql

helm install --name db ./helm/mysql/

helm install --name microservice ./helm/microservice/