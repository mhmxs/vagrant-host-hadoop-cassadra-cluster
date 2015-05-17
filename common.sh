#!/usr/bin/env bash

apt-get update && apt-get -y install curl git htop docker.io

echo "DOCKER_OPTS='-H tcp://0.0.0.0:2375'"
service docker restart

echo "sudo su" >> /home/vagrant/.bashrc
