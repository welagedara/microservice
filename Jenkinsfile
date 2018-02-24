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
        env.SPRING_PROFILES_ACTIVE=dev

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
                    sh 'echo ${SPRING_PROFILES_ACTIVE}'
                    sh 'curl -k https://www.w3schools.com/angular/customers.php'
                    sh './gradlew build'
                    //sh 'ls'
                    //sh "echo ${GIT_COMMIT_HASH}"
                    //sh './gradlew -DSPRING_PROFILES_ACTIVE=dev clean build'
            }
        }



        //docker image build
        stage('Dockerize & Publish') {
            container('docker') {
                    sh 'ls'
                    //sh './gradlew clean build'
                    //sh 'ls'
                    //sh "echo ${GIT_COMMIT_HASH}"
                    //sh './gradlew -DSPRING_PROFILES_ACTIVE=dev clean build'
            }
        }

        //publish

    }
}