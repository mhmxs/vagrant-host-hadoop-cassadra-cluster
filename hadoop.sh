#!/usr/bin/env bash

sh /vagrant/common.sh "$@"

docker build -t mhmxs/hadoop-docker:2.6.0 /vagrant/hadoop-docker

