#!/bin/sh

# This script pushes the MySQL Image to the cloud. Assumes the Microservice Image is already in the cloud

CONTAINER_NAME=mysql-default
IMAGE_NAME=my-mysql
TARGET_IMAGE_NAME=${1:-pubuduwelagedara/mysql}
IMAGE_TAG={2:-latest}
# TODO: 2/17/18 Use this in sed command
MYSQL_DATABASE_NAME=microservice

echo "Removing existing Containers"
containerId=`docker ps -qa --filter "name=$CONTAINER_NAME"`
if [ -n "$containerId" ]
then
	echo "Stopping and removing an existing container"
	docker stop $CONTAINER_NAME
	docker rm -f $CONTAINER_NAME
fi

echo "Removing existing Images"
docker rmi $IMAGE_NAME:$IMAGE_TAG 2>/dev/null

# Remove the old MySQL files in the directory
rm ./helm/mysql-v2/2-schema.sql 2>/dev/null
rm ./helm/mysql-v2/3-data.sql 2>/dev/null

# Adding this line in every script because MySQL throws an error when the Database is not selected in every Script
sed '1 s/^/USE \`microservice\`;/' ./src/main/resources/db/schema.sql > ./helm/mysql-v2/2-schema.sql
sed '1 s/^/USE \`microservice\`;/' ./src/main/resources/db/data.sql > ./helm/mysql-v2/3-data.sql

echo "Building Docker Image"
docker build -t "$IMAGE_NAME:$IMAGE_TAG" ./helm/mysql-v2/

# push the image to Docker Hub
docker tag $IMAGE_NAME:$IMAGE_TAG $TARGET_IMAGE_NAME:$IMAGE_TAG
docker push $TARGET_IMAGE_NAME:$IMAGE_TAG

# Use MySQL stable installation from Helm
helm install --name db --set image=$TARGET_IMAGE_NAME --set imageTag=$IMAGE_TAG --set service.type=NodePort stable/mysql

# Install MySQL from Helm
helm install --name microservice ./helm/microservice/