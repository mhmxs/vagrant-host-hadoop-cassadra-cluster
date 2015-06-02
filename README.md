# vagrant-host-hadoop-cassadra-cluster
Vagrant environment to configure and test Hadoop cluster with Cassandra

This project aims to configure and run Dockerized Hadoop and Cassandra cluster on Vagrant hosts, with Weave networking, Swarm cluster, and automatic DNS registration via docker-spy. To build the environment follow the steps below.

```
git clone https://github.com/mhmxs/vagrant-host-hadoop-cassadra-cluster.git
cd vagrant-host-hadoop-cassadra-cluster
git submodule update --init
cd hadoop-docker && git checkout 2.6.0
cd .. && git checkout master
vagrant up
```

If you have limited memory in your machine, you have to start some of the nodes by hand. The number of nodes depends on you memory, swarm and master require 512, slaves 1024 Mb of RAM.
```
vagrant up swarm
vagrant up master
vagrant up slave1
```

Take a coffee, order a pizza, it takes long time to download Vagrant boxes, Docker containers, other dependencies and than build them together.

Configured servers:

  * Swarm manager node with DNS service
  * Hadoop master server called master (hadoop: JobHistoryServer, NodeManager, ResourceManager, SecondaryNameNode, DataNode, NameNode)
  * 3 slave server (cassandra, hadoop: DataNode, NodeManager), named slave1, slave2, slave3

Start weave network, create a swarm cluster and initialize the manager itself
```
vagrant ssh swarm
weave launch
docker run --rm swarm create > /vagrant/currenttoken
docker run -d -p 1234:2375 swarm manage token://$(cat /vagrant/currenttoken)
```

Let's join to the network and the cluster too (each node requires a new terminal window)

all other node and swarm too
```
weave launch 192.168.50.15
docker run -d swarm join --addr=$(ifconfig eth1 | awk '/inet addr/{print substr($2,6)}'):2375 token://$(cat /vagrant/currenttoken)
```

Back to Swarm manager and check Swarm cluster, and boost up a DNS server
```
docker -H tcp://192.168.50.15:1234 info
docker run --name docker-spy -e "DOCKER_HOST=tcp://192.168.50.15:1234" -e "DNS_DOMAIN=lo" -p 53:53/udp -p 53:53 -v /var/run/docker.sock:/var/run/docker.sock iverberk/docker-spy
```

Start Docker containers on hosts

slave1
```
nohup docker -H tcp://192.168.50.15:1234 run --name cassandra-slave1 --dns 192.168.50.15 -h cassandra1.lo -e "PUBLIC_INTERFACE=eth0" -e "CASSANDRA_CLUSTERNAME=HadoopTest" -e "CASSANDRA_TOKEN=-9223372036854775808" -t mhmxs/cassandra-cluster > cassandra.log 2>&1 &
docker -H tcp://192.168.50.15:1234 run --name hadoop-slave1 --link cassandra-slave1:cassandra --dns 192.168.50.15 -h slave1.lo -e "MASTER=master.lo" -e "SLAVES=slave1.lo,slave2.lo,slave3.lo" -it mhmxs/hadoop-docker:2.6.0 /etc/bootstrap.sh -bash
```

slave2
```
nohup docker -H tcp://192.168.50.15:1234 run --name cassandra-slave2 --dns 192.168.50.15 -h cassandra2.lo -e "PUBLIC_INTERFACE=eth0" -e "CASSANDRA_CLUSTERNAME=HadoopTest" -e "CASSANDRA_SEEDS=cassandra1.lo" -e "CASSANDRA_TOKEN=-3074457345618258603" -t mhmxs/cassandra-cluster > cassandra.log 2>&1 &
docker -H tcp://192.168.50.15:1234 run --name hadoop-slave2 --link cassandra-slave2:cassandra --dns 192.168.50.15 -h slave2.lo -e "MASTER=master.lo" -e "SLAVES=slave1.lo,slave2.lo,slave3.lo" -it mhmxs/hadoop-docker:2.6.0 /etc/bootstrap.sh -bash
```

slave3
```
nohup docker -H tcp://192.168.50.15:1234 run --name cassandra-slave3 --dns 192.168.50.15 -h cassandra3.lo -e "PUBLIC_INTERFACE=eth0" -e "CASSANDRA_CLUSTERNAME=HadoopTest" -e "CASSANDRA_SEEDS=cassandra1.lo" -e "CASSANDRA_TOKEN=3074457345618258602" -t mhmxs/cassandra-cluster > cassandra.log 2>&1 &
docker -H tcp://192.168.50.15:1234 run --name hadoop-slave3 --link cassandra-slave3:cassandra --dns 192.168.50.15 -h slave3.lo -e "MASTER=master.lo" -e "SLAVES=slave1.lo,slave2.lo,slave3.lo" -it mhmxs/hadoop-docker:2.6.0 /etc/bootstrap.sh -bash
```

master
```
docker -H tcp://192.168.50.15:1234 run --name hadoop-master --dns 192.168.50.15 -h master.lo -e "SLAVES=slave1.lo,slave2.lo,slave3.lo" -it mhmxs/hadoop-docker:2.6.0 /etc/bootstrap.sh -bash
```


