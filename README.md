# vagrant-host-hadoop-cassadra-cluster
Vagrant environment to configure and test Hadoop cluster with Cassandra

This project aims to configure and run Dockerized Hadoop and Cassandra cluster on Vagrant hosts. To build the environment follow the steps below.

 * git clone https://github.com/mhmxs/vagrant-host-hadoop-cassadra-cluster.git
 * cd vagrant-host-hadoop-cassadra-cluster
 * git submodule update --init
 * git pull --recurse-submodules
 * vagrant up

Take a coffee, order a pizza, it takes long time to download Vagrant boxes, Docker containers, and other dependencies.

Now we have a Hadoop NameNode server called namenode, and 3 Casandra and Hadoop DataNode servers, named cassandraa, cassandrab, cassandrac, up and running.

Let's start Docker containers manually (each node requires a new terminal window)
 * vagrant ssh cassandraa
 * nohup docker run -e "PUBLIC_IP=192.168.50.1" -e "CASSANDRA_CLUSTERNAME=HadoopTest" -e "CASSANDRA_SEEDS=192.168.50.1,192.168.50.2,192.168.50.3" -e "CASSANDRA_TOKEN=-9223372036854775808" --name=cassandra -p 9042:9042 -p 9160:9160 -p 7000:7000 -p 7199:7199 -t mhmxs/cassandra > cassandra.log 2>&1 &
 * docker run --name hadoop -p 50020:50020 -p 50090:50090 -p 50070:50070 -p 50010:50010 -p 50075:50075 -p 8031:8031 -p 8032:8032 -p 8033:8033 -p 8040:8040 -p 8042:8042 -p 49707:49707 -p 2122:2122 -p 8030:8030 -it mhmxs/hadoop /etc/bootstrap.sh -bash

Next node
 * vagrant ssh cassandrab
 * nohup docker run -e "PUBLIC_IP=192.168.50.2" -e "CASSANDRA_CLUSTERNAME=HadoopTest" -e "CASSANDRA_SEEDS=192.168.50.1,192.168.50.2,192.168.50.3" -e "CASSANDRA_TOKEN=-3074457345618258603" --name=cassandra -p 9042:9042 -p 9160:9160 -p 7000:7000 -p 7199:7199 -t mhmxs/cassandra > cassandra.log 2>&1 &
 * docker run --name hadoop -p 50020:50020 -p 50090:50090 -p 50070:50070 -p 50010:50010 -p 50075:50075 -p 8031:8031 -p 8032:8032 -p 8033:8033 -p 8040:8040 -p 8042:8042 -p 49707:49707 -p 2122:2122 -p 8030:8030 -it mhmxs/hadoop /etc/bootstrap.sh -bash

Next node
 * vagrant ssh cassandrac
 * nohup docker run -e "PUBLIC_IP=192.168.50.3" -e "CASSANDRA_CLUSTERNAME=HadoopTest" -e "CASSANDRA_SEEDS=192.168.50.1,192.168.50.2,192.168.50.3" -e "CASSANDRA_TOKEN=3074457345618258602" --name=cassandra -p 9042:9042 -p 9160:9160 -p 7000:7000 -p 7199:7199 -t mhmxs/cassandra > cassandra.log 2>&1 &
 * docker run --name hadoop -p 50020:50020 -p 50090:50090 -p 50070:50070 -p 50010:50010 -p 50075:50075 -p 8031:8031 -p 8032:8032 -p 8033:8033 -p 8040:8040 -p 8042:8042 -p 49707:49707 -p 2122:2122 -p 8030:8030 -it mhmxs/hadoop /etc/bootstrap.sh -bash

Cassandra cluster is running, and DataNodes are waiting for master.
 * vagrant ssh namenode
 * docker run --name hadoop -e "MASTER=true" -p 50020:50020 -p 50090:50090 -p 50070:50070 -p 50010:50010 -p 50075:50075 -p 9000:9000 -p 8031:8031 -p 8032:8032 -p 8033:8033 -p 8040:8040 -p 8042:8042 -p 49707:49707 -p 2122:2122 -p 8088:8088 -p 8030:8030 -it mhmxs/hadoop /etc/bootstrap.sh -bash

To load some test data into Cassandra, on cassabdraa run the following
 * $(cat > db.tmp << EOF
create keyspace HadoopTest with strategy_options = {replication_factor:2} and placement_strategy = 'org.apache.cassandra.locator.SimpleStrategy';
use HadoopTest;
create column family content with comparator = UTF8Type and key_validation_class = UTF8Type and default_validation_class = UTF8Type and column_metadata = [ {column_name: text, validation_class:UTF8Type} ];
set content['apple']['text'] = 'apple apple red apple bumm';
set content['peach']['text'] = 'peach peach yellow peach bumm';
EOF) && cassandra-cli -h cassandraa -f db.tmp && rm db.tmp

Cassandra filled with test data, NameNode is running and ready to run jobs. For more details visit http://localhost:50070 and http://localhost:8088.

