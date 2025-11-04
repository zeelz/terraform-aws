#!/bin/bash

# update yum repo
sudo dnf update -y

# installing docker
sudo dnf install -y docker

# enable docker as a service
sudo systemctl start docker
sudo systemctl enable --now docker

# add ec2-user to docker group
sudo usermod -aG docker ec2-user

# activate group assignment
sudo newgrp docker

# echo pull docker image
# docker pull zeelz/node-app-devops-test

# echo run docker container
docker run -d --restart unless-stopped -p 3300:3300 zeelz/node-app-devops-test