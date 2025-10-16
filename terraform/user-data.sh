#!/bin/bash

# update yum repo
sudo yum update -y

# check docker yum repo
sudo yum search docker

# installing docker
sudo yum install docker -y

# enable docker as a service
systemctl enable --now docker

# add ec2-user to docker group
sudo usermod -aG docker ec2-user

# activate group assignment
sudo newgrp docker

# echo pull docker image
docker pull zeelz/node-app-devops-test

# echo run docker container
docker run -d --restart unless-stopped -p 3300:3300 zeelz/node-app-devops-test