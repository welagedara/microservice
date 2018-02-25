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

        git 'https://github.com/welagedara/microservice.git'
        env.MYTOOL_VERSION = '1.33'
        env.GIT_COMMIT_HASH=library.getCommitHash()
        env.GIT_CURRENT_BRANCH=library.getCurrentBranch()
        sh 'hash...'
        sh 'git rev-parse --short HEAD'

        println "${GIT_COMMIT_HASH}"
        println "${GIT_CURRENT_BRANCH}"
        //println "${BRANCH_NAME}"

        /*
        if [[ "$(docker images -q myimage:mytag 2> /dev/null)" == "" ]]; then
          # do something
        fi
        */
        println "Environment is ${KUBERNETES_ENVIRONMENT}"

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
        stage('Dockerize & Publish') {
            container('docker') {
                    sh 'ls build/libs'
                    sh 'rm ./docker/microservice/microservice-0.0.1.jar 2>/dev/null'
                    sh 'cp ./build/libs/microservice-0.0.1.jar ./docker/microservice/'
                    sh "docker build -t microservice:${GIT_COMMIT_HASH} ./docker/microservice/"
                    sh 'docker images | grep microservice'
                    sh "docker tag microservice:${GIT_COMMIT_HASH} gcr.io/kubernetes-195622/microservice:${GIT_COMMIT_HASH}"
                    withDockerRegistry([credentialsId: 'gcr:Kubernetes', url: 'https://gcr.io']) {
                        sh "docker push gcr.io/kubernetes-195622/microservice:${GIT_COMMIT_HASH}"
                    }


                    //sh './gradlew clean build'
                    //sh 'ls'
                    //sh "echo ${GIT_COMMIT_HASH}"
                    //sh './gradlew -DSPRING_PROFILES_ACTIVE=dev clean build'
            }
        }

        //deploy
        stage('Deploy') {
            container('helm') {
                    sh 'helm list'
                    sh "helm install --name microservice ./helm/microservice/"

                    //sh './gradlew clean build'
                    //sh 'ls'
                    //sh "echo ${GIT_COMMIT_HASH}"
                    //sh './gradlew -DSPRING_PROFILES_ACTIVE=dev clean build'
            }
        }

    }
}