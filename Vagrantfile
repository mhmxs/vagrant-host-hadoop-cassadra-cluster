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
		slave.vm.network "private_network", ip: "192.168.50.1"
		
		slave.vm.provision :shell, inline: "hostname slave1 && sh /vagrant/cassandra.sh"
	end
	
	config.vm.define "slave2" do |slave|
		slave.vm.network "private_network", ip: "192.168.50.2"
	
		slave.vm.provision :shell, inline: "hostname slave2 && sh /vagrant/cassandra.sh"
	end
	
	config.vm.define "slave3" do |slave|
		slave.vm.network "private_network", ip: "192.168.50.3"

		slave.vm.provision :shell, inline: "hostname slave3 && sh /vagrant/cassandra.sh"
	end
	
	config.vm.define "master" do |master|
		master.vm.network "private_network", ip: "192.168.50.4"

		config.vm.provision :shell, inline: "hostname master && sh /vagrant/hadoop.sh"
		
		config.vm.provider :virtualbox do |vb|
			vb.customize ["modifyvm", :id, "--memory", "1536"]
		end
	end
	
	#config.vm.define "swarm" do |sw|
		#sw.vm.network "private_network", ip: "192.168.50.5"
		#sw.vm.network "forwarded_port", guest: 2375, host: 2375

		#sw.vm.provision :shell, inline: "hostname swarm && sh /vagrant/swarm.sh"

		#config.vm.provider :virtualbox do |vb|
			#vb.customize ["modifyvm", :id, "--memory", "512"]
		#end
	#end
end
