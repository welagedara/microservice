#!/bin/sh

# You need to have a Docker Machine created and connected to to run this script( If you have docker machine)

minikube start

# Use Docker demon on the Mac
eval $(minikube docker-env)

# To change context back to Minikube
# kubectl config use-context minikube
