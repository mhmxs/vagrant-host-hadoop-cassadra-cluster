#!/usr/bin/env bash

sh /vagrant/docker.sh

docker build -t mhmxs/hadoop-docker:2.6.0 /vagrant/hadoop-docker

