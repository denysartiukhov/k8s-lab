#!/bin/bash
sudo yum update -y && sudo yum install -y docker
sudo sudo systemctl start docker
sudo usermod -aG docker ec2-user
sudo curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
sudo usermod -aG docker $USER && newgrp docker
#sudo minikube start --driver=docker