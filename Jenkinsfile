def label = "mypod-${UUID.randomUUID().toString()}"

podTemplate(label: label, containers: [
    containerTemplate(name: 'maven', image: 'maven:3.3.9-jdk-8-alpine', ttyEnabled: true, command: 'cat'),
    containerTemplate(name: 'golang', image: 'golang:1.8.0', ttyEnabled: true, command: 'cat')
  ]) {

    node(label) {
        stage('Get a Maven project') {
            git 'https://github.com/jenkinsci/kubernetes-plugin.git'
            container('maven') {
                stage('Build a Maven project') {
                    //sh 'mvn -B clean install'
                    sh 'pwd'
                    sh 'ls'
                }
            }
        }

        stage('Get a Golang project') {
            git url: 'https://github.com/hashicorp/terraform.git'
            container('golang') {
                // stage('Build a Go project') {
                //     sh """
                //     mkdir -p /go/src/github.com/hashicorp
                //     ln -s `pwd` /go/src/github.com/hashicorp/terraform
                //     cd /go/src/github.com/hashicorp/terraform && make core-dev
                //     """
                // }
                stage('Build a Go project') {
                    sh """
                    pwd
                    ls
                    """
                }
            }
        }

    }
}