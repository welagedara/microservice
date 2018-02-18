#!/bin/sh

CONTAINER_NAME=mysql-default
IMAGE_NAME=my-mysql
IMAGE_TAG=latest
MYSQL_ROOT_PASSWORD=root
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
docker rmi $IMAGE_NAME:$tag 2>/dev/null

# Remove the old MySQL files in the directory
rm ./util/mysql/2-schema.sql 2>/dev/null
rm ./util/mysql/3-data.sql 2>/dev/null

# Adding this line in every script because MySQL throws an error when the Database is not selected in every Script
sed '1 s/^/USE \`microservice\`;/' ./src/main/resources/db/schema.sql > ./util/mysql/2-schema.sql
sed '1 s/^/USE \`microservice\`;/' ./src/main/resources/db/data.sql > ./util/mysql/3-data.sql

echo "Building Docker Image"
docker build -t "$IMAGE_NAME:$IMAGE_TAG" ./util/mysql/

echo "Running the Container"
docker run -d --name=$CONTAINER_NAME -p 3306:3306 -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD $IMAGE_NAME:$IMAGE_TAG

echo "Listing the Containers"
docker ps

