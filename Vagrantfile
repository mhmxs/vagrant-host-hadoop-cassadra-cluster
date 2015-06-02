# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box = "ubuntu/vivid64"

    config.vm.provider "virtualbox" do |v|
        v.memory = 1024
    end

    config.vm.box_check_update = false
	
	config.vm.define "slave1" do |slave|
		slave.vm.network "private_network", ip: "192.168.50.11"
		
		slave.vm.provision :shell, inline: "sh /vagrant/cassandra.sh 10.2.0.11/16 10.2.11.0/24"
	end
	
	config.vm.define "slave2" do |slave|
		slave.vm.network "private_network", ip: "192.168.50.12"
	
		slave.vm.provision :shell, inline: "sh /vagrant/cassandra.sh 10.2.0.12/16 10.2.12.0/24"
	end
	
	config.vm.define "slave3" do |slave|
		slave.vm.network "private_network", ip: "192.168.50.13"

		slave.vm.provision :shell, inline: "sh /vagrant/cassandra.sh 10.2.0.13/16 10.2.13.0/24"
	end
	
	config.vm.define "master" do |master|
		master.vm.network "private_network", ip: "192.168.50.14"

		master.vm.provision :shell, inline: "sh /vagrant/hadoop.sh 10.2.0.14/16 10.2.14.0/24"
		
		config.vm.provider :virtualbox do |vb|
			vb.customize ["modifyvm", :id, "--memory", "768"]
		end
	end
	
	config.vm.define "swarm" do |sw|
		sw.vm.network "private_network", ip: "192.168.50.15"

		sw.vm.provision :shell, inline: "sh /vagrant/swarm.sh 10.2.0.15/16 10.2.15.0/24"

		config.vm.provider :virtualbox do |vb|
			vb.customize ["modifyvm", :id, "--memory", "512"]
		end
	end
end
