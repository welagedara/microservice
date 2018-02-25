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
        env.CHART_LOCATION='./helm/microservice/'
        env.HELM_NAME = 'microservice'
        env.DOCKER_REPOSITORY='gcr.io/kubernetes-195622/'
        env.DOCKER_IMAGE_NAME='microservice'

        sh 'echo lsssssss'
        sh 'ls'

        git 'https://github.com/welagedara/microservice.git'
        env.MYTOOL_VERSION = '1.33'

        //sh "git rev-parse --short HEAD > commit-hash.txt"
        //env.GIT_COMMIT_HASH=readFile('commit-hash.txt').trim()
        env.GIT_COMMIT_HASH=sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
        env.GIT_CURRENT_BRANCH=library.getCurrentBranch()
        println 'hash...'
        sh 'git remote show origin'
        sh 'git rev-parse --short HEAD'
        sh "git checkout ${BRANCH_NAME}"
        sh 'cat Jenkinsfile'

        env.GIT_COMMIT_HASH=sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()

        println "${GIT_COMMIT_HASH}"
        println "${GIT_CURRENT_BRANCH}"
        //println "${BRANCH_NAME}"

        /*
        if [[ "$(docker images -q myimage:mytag 2> /dev/null)" == "" ]]; then
          # do something
        fi
        */

        println "Environment is ${ENVIRONMENT}"

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

        //stages

        //build
        stage('Build') {
            container('java') {
                    sh 'cat /etc/hosts'
                    sh 'curl -k https://www.w3schools.com/angular/customers.php'
                    // TODO: 2/17/18 Enable tests
                    sh './gradlew clean build -x test'
                    //sh 'ls'
                    //sh "echo ${GIT_COMMIT_HASH}"
                    //sh './gradlew -DSPRING_PROFILES_ACTIVE=dev clean build'
            }
        }



        //docker image build
        stage('Dockerize') {
            container('docker') {
                    sh 'ls build/libs'
                    sh 'rm ./docker/microservice/microservice-0.0.1.jar 2>/dev/null'
                    sh 'cp ./build/libs/microservice-0.0.1.jar ./docker/microservice/'
                    sh "docker build -t microservice:${GIT_COMMIT_HASH} ./docker/microservice/"
                    sh 'docker images | grep microservice'


                    //sh 'echo removingggggggggggggggg'
                    //sh "docker rmi gcr.io/kubernetes-195622/microservice:${GIT_COMMIT_HASH}"
                    //sh 'docker images'


                    //sh './gradlew clean build'
                    //sh 'ls'
                    //sh "echo ${GIT_COMMIT_HASH}"
                    //sh './gradlew -DSPRING_PROFILES_ACTIVE=dev clean build'
            }
        }

        // Publish the Image to a Docker Registry
        // Environments only qa( because you do not build the Image between the Environments)
        stage('Publish') {
            container('docker') {

                    sh "docker tag ${DOCKER_IMAGE_NAME}:${GIT_COMMIT_HASH} ${DOCKER_REPOSITORY}${DOCKER_IMAGE_NAME}:${GIT_COMMIT_HASH}"

                    // Publish to Google Container Engine
                    withDockerRegistry([credentialsId: 'gcr:Kubernetes', url: 'https://gcr.io']) {
                        sh "docker push ${DOCKER_REPOSITORY}${DOCKER_IMAGE_NAME}:${GIT_COMMIT_HASH}"
                    }
            }
        }

        // Deploy the App.
        // Environments qa, staging & production
        stage('Deploy') {
            container('helm') {
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