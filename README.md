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
Deploy the App using the Dockerfile in ./docker/microservice/
```
./3-docker_deploy-microservice-v2.sh
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

Deploy MySQL. Note that this Deployment uses Config Maps to initialize the Database.
```
./6-kubectl_deploy-mysql.sh
```
Deploy MySQL( Pass TARGET_IMAGE_NAME to push it to your own Image Repository). By default the Service will be deployed in LoadBalancer configuration. Furthermore qa Spring Profile will be activated. imagePullPolicy in the Deployment is set to Always to make sure the image gets downloaded everytime.
```
./7-kubectl_deploy-microservice.sh TARGET_IMAGE_NAME
```
Clean up
```
./8-kubectl_cleanup.sh
```

## Deploying on Kubernetes using Helm

Deploy the app with Helm using the below command. Note that this script will initialize the Database with a Config Map and that can be maximum 1MB in size( need to confirm this).
```
./9-helm_deploy.sh
```
Deploy the app with Helm using the below command. It will build the MySQL image with the initialization scripts. The script assumes your App image is already in built and pushed. 
```
./9-helm_deploy-v2.sh
```
Clean up
```
./9-helm_cleanup.sh
```

## Configuring Jenkins

### Adding the Pipeline to Jenkins
Open Blue Ocean Plugin.
![Alt text](/images/1.png?raw=true "Optional Title")
Click New Pipeline Button to create the new Pipeline.
![Alt text](/images/2.png?raw=true "Optional Title")
Jenkins will guide you through the rest of the process. You may need a GitHub Access Token to finish the configuration. If you do not have one Jenkins will guide you to do that.


### Adding Webhooks

Go to Credentials -> System -> Global Credentials and click Add Credentials.
![Alt text](/images/3.png?raw=true "Credentials")
Select Secret Text. Then add a Shared Secret between Jenkins and Your GitHub Project. 
![Alt text](/images/4.png?raw=true "Add the Shared Secret")
Go to Configuration( Manage Jenkins). Then click Advanced Button which comes under GitHub.
![Alt text](/images/5.png?raw=true "Manage Jenkins")
Select your Shared Secret. Then click Save.
![Alt text](/images/6.png?raw=true "Save the Secret")
Go to your GitHub Project Settings -> Webhooks. Click Add Webhook.
![Alt text](/images/7.png?raw=true "Webhook")
Payload URL will be <Your Jenkins URL>/github-webhook/. Select application/json as Content Type. Then select Send me everything under Triggers.
![Alt text](/images/8.png?raw=true "Webhook Configuration")
Now you are all set.
![Alt text](/images/9.png?raw=true "Webhook Configured")

## Discarded Directory

You might find some useful code snippets in ./discarded directory.

## References
 - [Spring Guidelines for Docker](https://spring.io/guides/gs/spring-boot-docker/)
 - [Docker Networking](https://rskupnik.github.io/docker_series_2_connecting_containers) 
 - [How to deploy Spring Boot on Kubernetes( Shows how Config Maps and Secrets are used)](https://github.com/IBM/spring-boot-microservices-on-kubernetes/blob/master/README.md)
 - [How to write the Jenkinsfile](https://github.com/jenkinsci/kubernetes-plugin) 
 
## Appendix


### Useful Commands

To build the app using Gradle and run the App 
```
./gradlew build && java -jar build/libs/microservice-0.0.1.jar
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