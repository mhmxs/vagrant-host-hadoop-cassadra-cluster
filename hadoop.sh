#!/usr/bin/env bash

apt-get update && apt-get -y install curl git htop docker.io
service docker restart

docker build -t mhmxs/hadoop /vagrant/hadoop-docker

echo "sudo su" >> /home/vagrant/.bashrc
