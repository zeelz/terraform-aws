#!/bin/bash

# update system
sudo apt update -y && sudo apt upgrade -y

# installing docker deps
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# add docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker.gpg

# add docker repo
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# update package index again
sudo apt update -y

sudo apt install -y docker-ce docker-ce-cli containerd.io

# start and enable docker as a service
sudo systemctl start docker
sudo systemctl enable docker

# add ubuntu to docker group
sudo usermod -aG docker ubuntu

# activate group assignment
sudo newgrp docker

# they say newgrp breaks execution flow. let's see
echo pull docker image
docker pull zeelz/node-app-devops-test

echo run docker container
docker run -d --restart unless-stopped -p 3300:3300 zeelz/node-app-devops-test



# curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
# sudo dpkg -i minikube_latest_amd64.deb

# minikube start

# alias kubectl='minikube kubectl --'