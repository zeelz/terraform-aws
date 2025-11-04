#!/bin/bash

# update apt repo
sudo apt update -y
sudo apt upgrade -y

# installing docker
sudo apt install -y docker

# enable docker as a service
sudo systemctl start docker
sudo systemctl enable --now docker

# add ubuntu to docker group
sudo usermod -aG docker ubuntu

# activate group assignment
sudo newgrp docker

# echo pull docker image
# docker pull zeelz/node-app-devops-test

# echo run docker container
docker run -d --restart unless-stopped -p 3300:3300 zeelz/node-app-devops-test