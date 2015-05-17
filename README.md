# vagrant-host-hadoop-cassadra-cluster
Vagrant environment to configure and test Hadoop cluster with Cassandra

This project aims to configure and run Dockerized Hadoop and Cassandra cluster on Vagrant hosts. To build the environment follow the steps below.

```
git clone https://github.com/mhmxs/vagrant-host-hadoop-cassadra-cluster.git
cd vagrant-host-hadoop-cassadra-cluster
git submodule update --init
git pull --recurse-submodules
vagrant up
```

If you have limited memory in your machine, you have to start nodes by hand. The number of nodes depends on you memory, master requires 1536 Mb, and slaves require 1024 Mb of RAM.
```
vagrant up master
vagrant up slave1
```

Take a coffee, order a pizza, it takes long time to download Vagrant boxes, Docker containers, other dependencies and than build them together.

Configured servers:

  * Hadoop master server called master ( JobHistoryServer, NodeManager, ResourceManager, SecondaryNameNode, DataNode, NameNode)
  * 3 slave server (DataNode, NodeManage), named slave1, slave2, slave3

Let's start Docker containers manually (each node requires a new terminal window)
```
vagrant ssh slave1
nohup docker run --name cassandra --net=host -e "PUBLIC_IP=192.168.50.1" -e "CASSANDRA_CLUSTERNAME=HadoopTest" -e "CASSANDRA_SEEDS=192.168.50.1,192.168.50.2,192.168.50.3" -e "CASSANDRA_TOKEN=-9223372036854775808" -t mhmxs/cassandra-cluster > cassandra.log 2>&1 &
docker run --name hadoop --net=host -e "MASTER_IP=192.168.50.4" -e "SLAVES=192.168.50.1 slave1,192.168.50.2 slave2,192.168.50.3 slave3" -it mhmxs/hadoop-docker:2.6.0 /etc/bootstrap.sh -bash
```

Next node
```
vagrant ssh slave2
nohup docker run --name cassandra --net=host -e "PUBLIC_IP=192.168.50.2" -e "CASSANDRA_CLUSTERNAME=HadoopTest" -e "CASSANDRA_SEEDS=192.168.50.1,192.168.50.2,192.168.50.3" -e "CASSANDRA_TOKEN=-3074457345618258603" -t mhmxs/cassandra-cluster > cassandra.log 2>&1 &
docker run --name hadoop --net=host -e "MASTER_IP=192.168.50.4" -e "SLAVES=192.168.50.1 slave1,192.168.50.2 slave2,192.168.50.3 slave3" -it mhmxs/hadoop-docker:2.6.0 /etc/bootstrap.sh -bash
```

Next node
```
vagrant ssh slave3
nohup docker run --name cassandra --net=host -e "PUBLIC_IP=192.168.50.3" -e "CASSANDRA_CLUSTERNAME=HadoopTest" -e "CASSANDRA_SEEDS=192.168.50.1,192.168.50.2,192.168.50.3" -e "CASSANDRA_TOKEN=3074457345618258602" -t mhmxs/cassandra-cluster > cassandra.log 2>&1 &
docker run --name hadoop --net=host -e "MASTER_IP=192.168.50.4" -e "SLAVES=192.168.50.1 slave1,192.168.50.2 slave2,192.168.50.3 slave3" -it mhmxs/hadoop-docker:2.6.0 /etc/bootstrap.sh -bash
```

Cassandra cluster is running, and slaves are waiting for master.
```
vagrant ssh master
docker run --name hadoop --net=host -e "MASTER=true" -e "MASTER_IP=192.168.50.4" -e "SLAVES=192.168.50.1 slave1,192.168.50.2 slave2,192.168.50.3 slave3" -it mhmxs/hadoop-docker:2.6.0 /etc/bootstrap.sh -bash
```

To load some test data into Cassandra, on one of the slaves and execute the following command.
```
$(cat > db.tmp << EOF
create keyspace HadoopTest with strategy_options = {replication_factor:2} and placement_strategy = 'org.apache.cassandra.locator.SimpleStrategy';
use HadoopTest;
create column family content with comparator = UTF8Type and key_validation_class = UTF8Type and default_validation_class = UTF8Type and column_metadata = [ {column_name: text, validation_class:UTF8Type} ];
set content['apple']['text'] = 'apple apple red apple bumm';
set content['peach']['text'] = 'peach peach yellow peach bumm';
EOF && cassandra-cli -h cassandraa -f db.tmp && rm db.tmp
```

Cassandra filled with test data, and the cluster is running and ready to run jobs.

