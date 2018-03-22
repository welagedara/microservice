# microservice

## Screenshots

Activity Page
![Alt text](/images/14.png?raw=true "Activity")

A Pull Request being Built in Staging Environment
![Alt text](/images/15.png?raw=true "PR being Built")

A Successful Pull Request Built in Staging Environment
![Alt text](/images/12.png?raw=true "PR Success")

Continuous Integration System notification to GitHub when a PR is being built.
![Alt text](/images/16.png?raw=true "GitHub")

Continuous Integration System notification to GitHub upon a successful PR build.
![Alt text](/images/11.png?raw=true "GitHub")

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
Jenkins will guide you through the rest of the process. Select GitHub then you may be asked to create a GitHub Access Token. 

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

### Adding Environment Variables

To add Environment Variables for your Cluster go to Manage Jenkins Section.
![Alt text](/images/13.png?raw=true "Environment Variables")

### Pull Request Build Strategy

In the Project Configuration select the option shown to prevent Branches associated with Pull Requests getting built twice.
![Alt text](/images/10.png?raw=true "Environment Variables")

## Discarded Directory

You might find some useful code snippets in ./discarded directory.

## ToDos

 - Handle Webhook Events from the Jenkinsfile( Commits, Tags, PRs)
 - Build the App
 - Push the App to Dockerhub or some private Repository
 - Deploy the App( Using helm)
 - Rollback ( Using Helm)
 - Infrastructure Configuration( In the Infrastructure Repo)
 - Make use of skipping stages in Jenkins Pipelines( When Directive)
 
## References
 - [Spring Guidelines for Docker](https://spring.io/guides/gs/spring-boot-docker/)
 - [Docker Networking](https://rskupnik.github.io/docker_series_2_connecting_containers) 
 - [How to deploy Spring Boot on Kubernetes( Shows how Config Maps and Secrets are used)](https://github.com/IBM/spring-boot-microservices-on-kubernetes/blob/master/README.md)
 - [How to write the Jenkinsfile](https://github.com/jenkinsci/kubernetes-plugin) 
 - [How to Configure GitHub Webhook](https://www.youtube.com/watch?v=Z3S2gMBUkBo) 
 - [How to Configure GitHub Webhook with a Shared Key](https://www.youtube.com/watch?v=wrZMj0YQubc) 
 
