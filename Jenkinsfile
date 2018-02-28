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
        env.HELM_REVISON=''
        env.DOCKER_REPOSITORY='gcr.io/kubernetes-195622/'
        env.DOCKER_IMAGE_NAME='microservice'
        env.DOCKERFILE_LOCATION='./docker/microservice/'

        // The Environment comes from Jenkins. Add this variable to Jenkins
        println "[Jenkinsfile INFO] Current Environment is ${ENVIRONMENT}"

        // Code checkout
        checkout scm
        sh 'git status' // Print status
        env.GIT_COMMIT_HASH=sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
        println "[Jenkinsfile INFO] Commit Hash is ${GIT_COMMIT_HASH}"

        env.SKIP_BUILD=false // This is to make sure we do not build the image if it exists

        // Pick the stages you want to execute. Set ENVIRONMENT in Jenkins
        env.SKIP_STAGE_PREBUILD=false
        env.SKIP_STAGE_BUILD=false
        env.SKIP_STAGE_DOCKERIZE=false
        env.SKIP_STAGE_PUBLISH=false
        env.SKIP_STAGE_DRY_RUN=false
        env.SKIP_STAGE_DEPLOY=false

        // Stages of the Deployment

        // Prebuild
        // Here we check whether the App has been built before and an Image available
        // Also we make a note of the Helm Revison for Rollbacks
        stage('Prebuild') {

            // Remove if not needed
            library.setEnvironmentVariables()

            println 'Skip Stage Variables'
            println "${SKIP_STAGE_PREBUILD}"
            println "${SKIP_STAGE_BUILD}"
            println "${SKIP_STAGE_DOCKERIZE}"
            println "${SKIP_STAGE_PUBLISH}"
            println "${SKIP_STAGE_PUBLISH}"
            println "${SKIP_STAGE_DEPLOY}"

            container('gcloud') {
                    println "[Jenkinsfile INFO] Stage Prebuild starting..."
                    if((env.SKIP_STAGE_PREBUILD).toBoolean() == true) {
                        println '[Jenkinsfile INFO] Skipped Image Check'
                    }else {
                        def shellCommand = "gcloud container images list-tags ${DOCKER_REPOSITORY}${DOCKER_IMAGE_NAME} --limit 9999 | grep ${GIT_COMMIT_HASH} | wc -l"
                        env.SKIP_BUILD = sh(returnStdout: true, script: shellCommand).trim().toInteger() > 0
                    }
            }

            container('helm') {
                    if((env.SKIP_STAGE_PREBUILD).toBoolean() == true) {
                        println '[Jenkinsfile INFO] Skipped Revision Check'
                    }else {
                        // Find the Current Helm Revison for Rollbacks
                        def firstDeployment = sh(returnStdout: true, script: "if helm list | grep ${HELM_NAME}; then echo 0; else echo 1; fi").trim().toBoolean()
                        if(firstDeployment == true) {
                            println '[Jenkinsfile INFO] First Deployment'
                        } else {
                            def helmString = sh(returnStdout: true, script: "helm list | grep ${HELM_NAME}").trim()
                            def splittedHelmString = helmString.split();
                            if(splittedHelmString.length > 2) {
                                println '[Jenkinsfile INFO] Not the first Deployment'
                                env.HELM_REVISON = helmString.split()[1]
                            }
                        }
                    }
                    println "[Jenkinsfile INFO] Stage Prebuild completed..."
            }
        }

        // Building the App
        // Environments qa and release( because you do not build the Image between the Environments)
        // Branches dev & release. When you merge the release Branch to dev Branch things get tricky
        stage('Build') {
            container('java') {
                    println "[Jenkinsfile INFO] Stage Build starting..."
                    if((env.SKIP_BUILD).toBoolean() == true || (env.SKIP_STAGE_BUILD).toBoolean() == true) {
                        println '[Jenkinsfile INFO] Skipped'
                    }else {
                        // TODO: 2/17/18 Enable tests
                        sh './gradlew clean build -x test'
                    }
                    println "[Jenkinsfile INFO] Stage Build completed..."
            }
        }

        // Dokerization of the App
        // Environments qa and staging( because you do not build the Image between the Environments)
        // Branches dev & release. When you merge the release Branch to dev Branch things get tricky
        stage('Dockerize') {
            container('gcloud') {
                    println "[Jenkinsfile INFO] Stage Dockerize starting..."
                    if((env.SKIP_BUILD).toBoolean() == true || (env.SKIP_STAGE_DOCKERIZE).toBoolean() == true) {
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
                    if((env.SKIP_BUILD).toBoolean() == true || (env.SKIP_STAGE_PUBLISH).toBoolean() == true) {
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
                    if((env.SKIP_STAGE_DRY_RUN).toBoolean() == true) {
                        println '[Jenkinsfile INFO] Skipped'
                    }else {
                        sh "helm upgrade --install --debug --dry-run --set image.repository=${DOCKER_REPOSITORY}${DOCKER_IMAGE_NAME} --set image.tag=${GIT_COMMIT_HASH} ${HELM_NAME} ${CHART_LOCATION}"
                    }
                    println "[Jenkinsfile INFO] Stage Dry Run completed..."
            }
        }

        // Deploy the App.
        // Environments qa, staging & production
        // Branches dev, release & master
        stage('Deploy') {
            container('helm') {
                    println "[Jenkinsfile INFO] Stage Deploy starting..."
                    if((env.SKIP_STAGE_DEPLOY).toBoolean() == true) {
                        println '[Jenkinsfile INFO] Skipped'
                    }else {
                        // Deploying the App
                        try{
                            sh "helm upgrade --install --set image.repository=${DOCKER_REPOSITORY}${DOCKER_IMAGE_NAME} --set image.tag=${GIT_COMMIT_HASH} ${HELM_NAME} ${CHART_LOCATION}"
                            sh 'helm list'
                            println "[Jenkinsfile INFO] Deployment success..."
                        }catch (err) {
                            if (env.HELM_REVISON != '') {
                                // Rollback
                                println "[Jenkinsfile INFO] Something went wrong.  Rolling back..."
                                sh "helm rollback ${HELM_NAME} ${HELM_REVISON}"
                            } else {
                                println "[Jenkinsfile INFO] No rolling back since this is the first Deployment..."
                            }
                            currentBuild.result = 'FAILURE'
                        }finally {
                            println "[Jenkinsfile INFO] Deploying the App is done..."
                        }
                    }
                    println "[Jenkinsfile INFO] Stage Deploy completed..."
            }
        }

    }
}