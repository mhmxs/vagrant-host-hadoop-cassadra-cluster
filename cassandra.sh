#!/usr/bin/env bash

sh /vagrant/hadoop.sh

docker build -t mhmxs/cassandra-cluster /vagrant/docker-cassandra/cassandra-cluster
