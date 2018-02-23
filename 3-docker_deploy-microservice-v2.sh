#!/bin/sh

DOCKER_MACHINE_NAME=microservice
IMAGE_NAME=com.example/microservice
CONTAINER_NAME=microservice-default
MYSQL_ROOT_PASSWORD=root
MYSQL_CONTAINER_NAME=mysql-default
NETWORK=my-network

# TODO: 2/17/19 Check if the below line works if Docker Machine is not installed
hostIp=$(docker-machine ip $DOCKER_MACHINE_NAME 2> /dev/null || echo 127.0.0.1)
# tag=$(git rev-parse --short HEAD)
tag=latest

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

# Build the Image using withou using Gradle Plugin
echo "Building Docker Image"
./gradlew clean build
rm ./docker/microservice/microservice-0.0.1.jar 2>/dev/null
cp ./build/libs/microservice-0.0.1.jar ./docker/microservice/
docker build -t $IMAGE_NAME:$tag ./docker/microservice/

echo "Running the Container"
docker run -d --name=$CONTAINER_NAME -p 8080:8080 --network $NETWORK -e MYSQL_HOST=$MYSQL_CONTAINER_NAME -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD $IMAGE_NAME:$tag

echo "Listing the Containers"
docker ps

echo "App running on http://$hostIp:8080"