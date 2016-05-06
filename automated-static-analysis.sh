#!/bin/bash
set -e

brew cask install virtualbox
brew install docker-machine docker-compose
docker-machine rm -f concourse-sonar
docker-machine create --driver virtualbox concourse-sonar
sleep 5
VBoxManage controlvm "concourse-sonar" natpf1 "tcp-port8080,tcp,,8080,,8080"
VBoxManage controlvm "concourse-sonar" natpf1 "tcp-port9000,tcp,,9000,,9000"
VBoxManage controlvm "concourse-sonar" natpf1 "tcp-port9092,tcp,,9092,,9092"
#docker build -t concourse-sonarqube .
#docker run -p 8080:8080 concourse-sonarqube
cp /etc/resolv.conf concourse/
eval "$(docker-machine env concourse-sonar)"
docker-compose up

# Getting access to Git Repo
# automatically watch for repo changes
# sonar
# post JSON report to us
