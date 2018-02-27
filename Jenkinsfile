@Library('github.com/welagedara/pipeline-github-lib@master')

// TODO: 2/17/18 Use this Library to externalize the build process
def library = new com.example.Library()
def label = "mypod-${UUID.randomUUID().toString()}"

podTemplate(label: label, containers: [
    containerTemplate(name: 'java', image: 'airdock/oracle-jdk:1.8', ttyEnabled: true, command: 'cat'),
    // Below image has Docker
    containerTemplate(name: 'gcloud', image: 'google/cloud-sdk', command: 'cat', ttyEnabled: true),
    containerTemplate(name: 'helm', image: 'lachlanevenson/k8s-helm:v2.7.2', command: 'cat', ttyEnabled: true)
  ],
  volumes:[
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
  ]) {

    node(label) {

        // Environment Variables
        env.SOURCE_REPO='https://github.com/welagedara/microservice.git'
        env.CHART_LOCATION='./helm/microservice/'
        env.HELM_NAME = 'microservice'
        env.DOCKER_REPOSITORY='gcr.io/kubernetes-195622/'
        env.DOCKER_IMAGE_NAME='microservice'
        env.DOCKERFILE_LOCATION='./docker/microservice/'
        env.SKIP_BUILD=false // This is to make sure we do not build the image if it exists

        // The Environment comes from Jenkins. Add this variable to Jenkins
        println "[Jenkinsfile INFO] Current Environment is ${ENVIRONMENT}"

        // Code checkout
        git "${SOURCE_REPO}"
        sh "git checkout ${BRANCH_NAME}"
        env.GIT_COMMIT_HASH=sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
        println "[Jenkinsfile INFO] Commit Hash is ${GIT_COMMIT_HASH}"

        // Stages of the Deployment

        // Prebuild
        // Here we check whether the App has been built before and is available
        stage('Prebuild') {
            container('gcloud') {
                    println "[Jenkinsfile INFO] Stage Prebuild starting..."
                    env.SKIP_BUILD = sh(returnStdout: true, script: "gcloud container images list-tags ${DOCKER_REPOSITORY}${DOCKER_IMAGE_NAME} --limit 9999| grep ${GIT_COMMIT_HASH} | wc -l").trim().toInteger() > 0
                    println "[Jenkinsfile INFO] Stage Prebuild completed..."
            }
        }

        // Building the App
        // Environments qa and release( because you do not build the Image between the Environments)
        // Branches dev & release. When you merge the release Branch to dev Branch things get tricky
        stage('Build') {
            container('java') {
                    println "[Jenkinsfile INFO] Stage Build starting..."
                    if(env.SKIP_BUILD == true) {
                        println '[Jenkinsfile INFO] Skipped'
                    }else {
                        // TODO: 2/17/18 Enable tests
                        sh './gradlew clean build -x test'
                    }
                    println "[Jenkinsfile INFO] Stage Build completed..."
            }
        }

        // Dokerization of the App
        // Environments qa and release( because you do not build the Image between the Environments)
        // Branches dev & release. When you merge the release Branch to dev Branch things get tricky
        stage('Dockerize') {
            container('gcloud') {
                    println "[Jenkinsfile INFO] Stage Dockerize starting..."
                    if(env.SKIP_BUILD == true) {
                        println '[Jenkinsfile INFO] Skipped'
                    }else {
                        sh 'rm ./docker/microservice/microservice-0.0.1.jar 2>/dev/null'
                        sh "cp ./build/libs/microservice-0.0.1.jar ${DOCKERFILE_LOCATION}"
                        sh "docker build -t ${DOCKER_IMAGE_NAME}:${GIT_COMMIT_HASH} ${DOCKERFILE_LOCATION}"
                    }
                    println "[Jenkinsfile INFO] Stage Dockerize completed..."
            }
        }

        // Publish the Image to a Docker Registry
        // Environments qa and release( because you do not build the Image between the Environments)
        // Branches dev & release. When you merge the release Branch to dev Branch things get tricky
        stage('Publish') {
            container('gcloud') {
                    println "[Jenkinsfile INFO] Stage Publish starting..."
                    if(env.SKIP_BUILD == true) {
                        println '[Jenkinsfile INFO] Skipped'
                    }else {
                        sh "docker tag ${DOCKER_IMAGE_NAME}:${GIT_COMMIT_HASH} ${DOCKER_REPOSITORY}${DOCKER_IMAGE_NAME}:${GIT_COMMIT_HASH}"
                        // Publish to Google Container Registry
                        sh "gcloud docker -- push ${DOCKER_REPOSITORY}${DOCKER_IMAGE_NAME}:${GIT_COMMIT_HASH}"
                    }
                    println "[Jenkinsfile INFO] Stage Publish completed..."
            }
        }

        // Dry run
        // Environments qa, staging & production
        // Branches dev, release & master
        stage('Dry Run') {
            container('helm') {
                    println "[Jenkinsfile INFO] Stage Dry Run starting..."
                    sh "helm upgrade --dry-run --install --set image.repository=${DOCKER_REPOSITORY}${DOCKER_IMAGE_NAME} --set image.tag=${GIT_COMMIT_HASH} ${HELM_NAME} ${CHART_LOCATION}"
                    sh 'helm list'
                    println "[Jenkinsfile INFO] Stage Dry Run completed..."
            }
        }

        // Deploy the App.
        // Environments qa, staging & production
        // Branches dev, release & master
        stage('Deploy') {
            container('helm') {
                    println "[Jenkinsfile INFO] Stage Deploy starting..."
                    sh "helm upgrade --install --set image.repository=${DOCKER_REPOSITORY}${DOCKER_IMAGE_NAME} --set image.tag=${GIT_COMMIT_HASH} ${HELM_NAME} ${CHART_LOCATION}"
                    println "[Jenkinsfile INFO] Stage Deploy completed..."
            }
        }

        /*
        stage('Test') {
            container('helm') {
                try {
                        sh 'might fail'
                    } catch (err) {
                        echo "Caught: ${err}"
                        currentBuild.result = 'FAILURE'

                    } finally {
                            sh 'echo cleaninnnnnnng'
                            sh 'helm list'
                    }
             }

        }
        */


    }
}