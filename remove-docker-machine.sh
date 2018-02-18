#!/bin/sh

DOCKER_MACHINE_NAME=microservice

echo "Removing Docker Machine"
docker-machine rm $DOCKER_MACHINE_NAME

echo "Listing Docker Machines"
docker-machine ls

echo "Success"



