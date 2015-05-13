# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box = "ubuntu/vivid64"

    config.vm.provider "virtualbox" do |v|
        v.memory = 2048
    end

    config.vm.box_check_update = false

    config.vm.provision :shell, path: "hadoop.sh"

	config.vm.define "cassandraa" do |cassandra|
		cassandra.vm.network "private_network", ip: "192.168.50.1"
		cassandra.vm.network "forwarded_port", guest: 7199, host: 7199
		cassandra.vm.network "forwarded_port", guest: 9042, host: 9042
		cassandra.vm.network "forwarded_port", guest: 9160, host: 9160
		cassandra.vm.provision :shell, path: "cassandra.sh"
	end
	
	#config.vm.define "cassandrab" do |cassandra|
	#	cassandra.vm.network "private_network", ip: "192.168.50.2"
	#	cassandra.vm.provision :shell, path: "cassandra.sh"
	#end
	
	#config.vm.define "cassandrac" do |cassandra|
	#	cassandra.vm.network "private_network", ip: "192.168.50.3"
	#	cassandra.vm.provision :shell, path: "cassandra.sh"
	#end
	
	config.vm.define "namenode" do |nn|
		nn.vm.network "private_network", ip: "192.168.50.4"
		nn.vm.network "forwarded_port", guest: 50070, host: 50070
		nn.vm.network "forwarded_port", guest: 8088, host: 8088
		nn.vm.network "forwarded_port", guest: 8042, host: 8042
		nn.vm.network "forwarded_port", guest: 19888, host: 19888
		
		config.vm.provider :virtualbox do |vb|
			vb.customize ["modifyvm", :id, "--memory", "3072"]
		end
	end
end
