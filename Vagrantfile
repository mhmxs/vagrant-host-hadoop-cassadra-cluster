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
		slave.vm.hostname = "slave1"
		slave.vm.network "private_network", ip: "192.168.50.1"
		slave.vm.network "forwarded_port", guest: 7199, host: 7199
		slave.vm.network "forwarded_port", guest: 9042, host: 9042
		slave.vm.network "forwarded_port", guest: 9160, host: 9160
		
		slave.vm.provision :shell, path: "cassandra.sh"
	end
	
	config.vm.define "slave2" do |cassandra|
		slave.vm.hostname = "slave2"
		slave.vm.network "private_network", ip: "192.168.50.2"
	
		slave.vm.provision :shell, path: "cassandra.sh"
	end
	
	config.vm.define "slave3" do |slave|
		slave.vm.hostname = "slave3"
		slave.vm.network "private_network", ip: "192.168.50.3"

		slave.vm.provision :shell, path: "cassandra.sh"
	end
	
	config.vm.define "master" do |master|
		master.vm.hostname = "master"
		master.vm.network "private_network", ip: "192.168.50.4"
		master.vm.network "forwarded_port", guest: 50070, host: 50070
		master.vm.network "forwarded_port", guest: 8088, host: 8088
		master.vm.network "forwarded_port", guest: 8042, host: 8042
		master.vm.network "forwarded_port", guest: 19888, host: 19888  

		config.vm.provision :shell, path: "hadoop.sh"
		
		config.vm.provider :virtualbox do |vb|
			vb.customize ["modifyvm", :id, "--memory", "1536"]
		end
	end
	
	#config.vm.define "swarm" do |sw|
		#sw.vm.hostname = "swarn"
		#sw.vm.network "private_network", ip: "192.168.50.5"
		#sw.vm.network "forwarded_port", guest: 2375, host: 2375

		#sw.vm.provision :shell, path: "swarm.sh"

		#config.vm.provider :virtualbox do |vb|
			#vb.customize ["modifyvm", :id, "--memory", "512"]
		#end
	#end
end
