# microservice

## Deploying on Docker

Create Docker Machine. Use this only if you have Docker Machine installed.
```
./1-docker_create-docker-machine.sh
```
Deploy MySQL
```
./2-docker_deploy-mysql.sh
```
Deploy the App
```
./3-docker_deploy-microservice.sh
```
Clean up
```
./docker_cleanup.sh
```
Remove Docker Machine( optional)
```
./5-docker_remove-docker-machine.sh
```

## Deploying on Kubernetes using kubectl( By default qa profile will be activated)
Deploy MySQL
```
./6-kubectl_deploy-mysql.sh
```
Deploy MySQL( Pass TARGET_IMAGE_NAME to push it to your own Image Repository). By default the Service will be deployed in LoadBalancer configuration. Furthermore qa Spring Profile will be activated.
```
./7-kubectl_deploy-microservice.sh TARGET_IMAGE_NAME
```
Clean up
```
./8-kubectl_cleanup.sh
```

## Useful Commands

```
./gradlew build && java -jar build/libs/microservice-0.1.0-SNAPSHOT.jar
```
List Docker Machines
```
docker-machine ls
```
Create a Docker Machine
```
docker-machine create --driver virtualbox microservice
```
Connect to the Docker Machine
```
eval "$(docker-machine env microservice)"
```
List Docker Containers
```
docker ps
```
Build the Docker Image using Gradle. You have to pass the tag.
```
./gradlew build -Ptag=TAG_VALUE docker
```
To get the commit id from Git
```
git rev-parse --short HEAD
```
To use the Git commit id as the tag when building the Docker Image
```
./gradlew build -Ptag=$(git rev-parse --short HEAD) docker
```
Run the App
```
docker run -p 8080:8080 -t com.example/microservice
```
To change Spring Profile when running the App, pass SPRING_PROFILES_ACTIVE as an environment variable.
```
docker run -e "SPRING_PROFILES_ACTIVE=deployment" -p 8080:8080 -t com.example/microservice
```
To check Docker Logs from the Container
```
docker logs CONTAINER_ID
```
Or Log into the Container using the below command.
```
docker exec -it CONTAINER_ID /bin/bash
```

## Discarded Directory

You might find some useful code snippets in ./discarded directory.

## References
 - [Spring Guidelines for Docker](https://spring.io/guides/gs/spring-boot-docker/)
 - [Docker Networking](https://rskupnik.github.io/docker_series_2_connecting_containers) 
 - [How to deploy Spring Boot on Kubernetes( Shows how Config Maps and Secrets are used)](https://github.com/IBM/spring-boot-microservices-on-kubernetes/blob/master/README.md)
 - [How to write the Jenkinsfile](https://github.com/jenkinsci/kubernetes-plugin) 
 
 
 