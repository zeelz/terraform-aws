#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive
# update system
apt update -y
# apt upgrade -y ## will trigger kernel ui so don't

# installing docker deps
apt install -y apt-transport-https ca-certificates curl software-properties-common

# add docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker.gpg

# add docker repo
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

# update package index again
apt-get update -y

apt-get install -y docker-ce docker-ce-cli containerd.io

# start and enable docker as a service
systemctl start docker
systemctl enable docker

# add ubuntu to docker group
usermod -aG docker ubuntu

# they say newgrp breaks execution flow. let's see
# flow didn't break. docker pulled and ran ✅
# echo pull docker image
# docker pull zeelz/node-app-devops-test

# echo run docker container
# docker run -d --restart unless-stopped -p 3300:3300 zeelz/node-app-devops-test


### MINIKUBE INSTALL ###

# but minikube won't run cos' cloud-init is running this entire script as root, which minikube doesn't like
# suggestion is to run minikube with systemd service
# Exiting due to DRV_AS_ROOT: The "docker" driver should not be used with root privileges.
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb 
dpkg -i minikube_latest_amd64.deb

until docker info >/dev/null 2>&1; do
  echo waiting
  sleep 5
done

# minikube start as ubuntu. minikube forbids docker driver as root
sudo -u ubuntu minikube start --driver=docker

echo kubectl='minikube kubectl --' >> /home/ubuntu/.bashrc

### END -- MINIKUBE INSTALL ###

# ### Install Microk8s
# snap install microk8s --classic

# usermod -aG microk8s ubuntu

# mkdir -p /home/ubuntu/.kube
# chown -R ubuntu:ubuntu /home/ubuntu/.kube

# # Wait for microk8s
# microk8s status --wait-ready

# microk8s helm3 repo add headlamp https://kubernetes-sigs.github.io/headlamp/
# microk8s helm3 upgrade --install headlamp-dash headlamp/headlamp --namespace kube-system

# ### END - Install Microk8s