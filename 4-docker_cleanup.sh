#!/bin/sh

MICROSERVICE_CONTAINER_NAME=microservice-default
MICROSERVICE_IMAGE_NAME=com.example/microservice
MYSQL_CONTAINER_NAME=mysql-default
MYSQL_IMAGE_NAME=my-mysql
MYSQL_IMAGE_TAG=latest
NETWORK=my-network

tag=$(git rev-parse --short HEAD)

echo "Removing Docker Containers"
containerId=`docker ps -qa --filter "name=$MICROSERVICE_CONTAINER_NAME"`
if [ -n "$containerId" ]
then
   echo "Stopping and removing an existing container"
   docker stop $MICROSERVICE_CONTAINER_NAME
   docker rm -f $MICROSERVICE_CONTAINER_NAME
fi

echo "Removing Docker Containers"
containerId=`docker ps -qa --filter "name=$MYSQL_CONTAINER_NAME"`
if [ -n "$containerId" ]
then
   echo "Stopping and removing an existing container"
   docker stop $MYSQL_CONTAINER_NAME
   docker rm -f $MYSQL_CONTAINER_NAME
fi

echo "Removing Docker Images"
docker rmi $MICROSERVICE_IMAGE_NAME:$tag 2>/dev/null

docker rmi $MYSQL_IMAGE_NAME:$MYSQL_IMAGE_TAG 2>/dev/null

echo "Removing Docker Networks"
docker network rm $NETWORK

echo "Listing Docker Containers"
docker ps

echo "Listing Docker Images"
docker images

echo "Listing Docker Networks"
docker network ls

echo "Success"



