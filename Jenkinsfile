@Library('github.com/welagedara/pipeline-github-lib@master')

def library = new com.example.Library()
def label = "mypod-${UUID.randomUUID().toString()}"

podTemplate(label: label, containers: [
    containerTemplate(name: 'java', image: 'airdock/oracle-jdk:1.8', ttyEnabled: true, command: 'cat'),
    containerTemplate(name: 'docker', image: 'docker:1.12.6', command: 'cat', ttyEnabled: true),
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

        // The Environment comes from Jenkins. Add this variable to Jenkins
        println "[Jenkinsfile INFO] Current Environment is ${ENVIRONMENT}"

        // Code checkout
        git "${SOURCE_REPO}"
        sh "git checkout ${BRANCH_NAME}"
        env.GIT_COMMIT_HASH=sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
        println "[Jenkinsfile INFO] Commit Hash is ${GIT_COMMIT_HASH}"

        /*
        if [[ "$(docker images -q myimage:mytag 2> /dev/null)" == "" ]]; then
          # do something
        fi

        if (env.BRANCH_NAME =~ "PR-*" ) {
            println "PR Branch is ${BRANCH_NAME}"
        }
        
        if (env.BRANCH_NAME == "master" ) {
            println "master Branch is ${BRANCH_NAME}"
        }

        if (env.BRANCH_NAME == "dev" ) {
            println "dev Branch is ${BRANCH_NAME}"
        }

        if( env.BRANCH_NAME.startsWith("release-") ) {
         println "release Branch is ${BRANCH_NAME}"
        }
        */

        // Stages of the Deployment

        // Prebuild
        // Here we check whether the App has been built before and is available

        println "sdasdasdasd"
        println currentBuild.getPreviousBuild().displayName
        println currentBuild.getPreviousBuild().id
        println currentBuild.getPreviousBuild().description
        println currentBuild.getPreviousBuild().number
        //env.GIT_COMMIT_HASH=sh(returnStdout: true, script: "").trim()

        // Building the App
        // Environments qa and release( because you do not build the Image between the Environments)
        // Branches dev & release. When you merge the release Branch to dev Branch things get tricky
        stage('Build') {
            container('java') {
                    println "[Jenkinsfile INFO] Stage Build starting..."
                    // TODO: 2/17/18 Enable tests
                    sh './gradlew clean build -x test'
                    println "[Jenkinsfile INFO] Successfully built the App"
            }
        }

        // Dokerization of the App
        // Environments qa and release( because you do not build the Image between the Environments)
        // Branches dev & release. When you merge the release Branch to dev Branch things get tricky
        stage('Dockerize') {
            container('docker') {
                    println "[Jenkinsfile INFO] Stage Dockerize starting..."
                    def existentImage = sh(returnStdout: true, script: "docker images -q ${DOCKER_IMAGE_NAME}:b671aab 2> /dev/null").trim()
                    def nonExistentImage = sh(returnStdout: true, script: "docker images -q ${DOCKER_IMAGE_NAME}:${GIT_COMMIT_HASH} 2> /dev/null").trim()
                    println existentImage
                    println nonExistentImage
                    sh 'rm ./docker/microservice/microservice-0.0.1.jar 2>/dev/null'
                    sh "cp ./build/libs/microservice-0.0.1.jar ${DOCKERFILE_LOCATION}"
                    sh "docker build -t ${DOCKER_IMAGE_NAME}:${GIT_COMMIT_HASH} ${DOCKERFILE_LOCATION}"
                    sh 'docker images | grep microservice'
                    println "[Jenkinsfile INFO] Successfully Dockerized the App"
            }
        }

        // Publish the Image to a Docker Registry
        // Environments qa and release( because you do not build the Image between the Environments)
        // Branches dev & release. When you merge the release Branch to dev Branch things get tricky
        stage('Publish') {
            container('docker') {
                    println "[Jenkinsfile INFO] Stage Publish starting..."
                    sh "docker tag ${DOCKER_IMAGE_NAME}:${GIT_COMMIT_HASH} ${DOCKER_REPOSITORY}${DOCKER_IMAGE_NAME}:${GIT_COMMIT_HASH}"
                    // Publish to Google Container Registry
                    withDockerRegistry([credentialsId: 'gcr:Kubernetes', url: 'https://gcr.io']) {
                        sh "docker push ${DOCKER_REPOSITORY}${DOCKER_IMAGE_NAME}:${GIT_COMMIT_HASH}"
                    }
                    println "[Jenkinsfile INFO] Successfully published the Image to the Registry"
            }
        }

        // Deploy the App.
        // Environments qa, staging & production
        // Branches dev, release & master
        stage('Deploy') {
            container('helm') {
                    println "[Jenkinsfile INFO] Stage Deploy starting..."
                    sh "helm upgrade --install --set image.repository=${DOCKER_REPOSITORY}${DOCKER_IMAGE_NAME} --set image.tag=${GIT_COMMIT_HASH} ${HELM_NAME} ${CHART_LOCATION}"
                    println "[Jenkinsfile INFO] Success"
                    sh 'helm list'
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