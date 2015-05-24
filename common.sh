#!/usr/bin/env bash

# auto sudo su
if [ -z "$(cat /home/vagrant/.bashrc | grep 'sudo su')" ]; then
	echo "sudo su" >> /home/vagrant/.bashrc
fi

# force docker to start
sed -i "s/exit 0//" /etc/rc.local
if [ -z "$(cat /etc/rc.local | grep 'docker restart')" ]; then
        echo "service docker restart" >> /etc/rc.local
fi

cat > /etc/network/interfaces.d/weave.cfg << EOF
auto weave
iface weave inet static
        address $(echo $1 | sed "s|/.*||")
        network 10.2.0.0
        netmask 255.255.0.0
        broadcast 0.0.0.0
        bridge_ports none
        bridge_maxwaitout 0
EOF

apt-get update && apt-get -y install bridge-utils curl docker.io
echo "" > /etc/default/docker
service docker restart

if [ ! -f /usr/local/bin/weave ]; then
    wget -O /usr/local/bin/weave https://github.com/weaveworks/weave/releases/download/latest_release/weave
    chmod a+x /usr/local/bin/weave
fi

if [ -z "$(ifconfig | grep weave)" ]; then
    weave create-bridge
    ip addr add dev weave $1
fi

echo "DOCKER_OPTS='-H tcp://$(ifconfig eth1 | awk '/inet addr/{print substr($2,6)}'):2375 -H unix:///var/run/docker.sock --bridge=weave --fixed-cidr=$2'" > /etc/default/docker
service docker restart

docker pull swarm