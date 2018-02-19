#!/bin/sh

DOCKER_MACHINE_NAME=microservice

echo "Creating Docker Machine"
docker-machine create --driver virtualbox $DOCKER_MACHINE_NAME

echo "Listing Docker Machines"
docker-machine ls

echo "Connecting to Docker Machine"
eval "$(docker-machine env $DOCKER_MACHINE_NAME)"

echo "Success"



