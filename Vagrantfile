# -*- mode: ruby -*-
# vi: set ft=ruby :

#
# setup a docker and glusterfs environment
# 
# srv-gluster-01 - gluster server (+ salt master + consul bootstrap)
# srv-gluster-02 - gluster server
# srv-docker-01 - docker node (swarm master)
# srv-docker-02 - docker node
# srv-docker-03 - docker node

# Requirements:
# - hostmanager plugin installed: https://github.com/devopsgroup-io/vagrant-hostmanager
# - vbox guest plugin installed: https://github.com/dotless-de/vagrant-vbguest

#
# globals
#

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# get the vagrant root folder
vagrant_root = File.dirname(__FILE__)

# get the vb machine folder
line = `VBoxManage list systemproperties | grep "Default machine folder"`
machine_folder = line.split(':')[1].strip()
if machine_folder.to_s == ''
  abort("could not get virtualbox machinefolder. aborting.")
end

# set the path to the pillar and saltstack
stack = File.join(vagrant_root, 'salt', 'stack') 
pillar = File.join(vagrant_root, 'salt', 'pillar')
keys = File.join(vagrant_root, 'salt', 'keys')
etc = File.join(vagrant_root, 'salt', 'etc')
grains = File.join(vagrant_root, 'salt', 'grains')
#
# setup
#

# lets start configuring the machines
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  ## hostmanager plugin
  # automatically creates entries in /etc/hosts
  config.hostmanager.enabled = true
  # manage the vagrant host
  config.hostmanager.manage_host = true
  # manage the vagrant guests
  config.hostmanager.manage_guest = true
  # add private network ips
  config.hostmanager.ignore_private_ip = false
  # also add the offline vagrant hosts
  config.hostmanager.include_offline = true


  ## setup srv-gluster-01 
  # the machine is also our salt master
  config.vm.define "srv-gluster-01" do |node|
    node.vm.box = "debian/jessie64"
    node.vm.hostname = "srv-gluster-01"

    node.vm.network :private_network, ip: "192.168.56.101"

    node.hostmanager.aliases =  "salt consul"

    node.vm.synced_folder stack, "/srv/salt"
    node.vm.synced_folder pillar, "/srv/pillar"
    
    node.vm.provision :salt do |salt|
      salt.master_config = File.join(etc, 'master')
      salt.minion_config = File.join(etc, 'minion')
      salt.grains_config = File.join(grains, "srv-gluster-01")
      salt.master_key = File.join(keys, "srv-gluster-01" + '.pem')
      salt.master_pub = File.join(keys, "srv-gluster-01" + '.pub')
      salt.minion_key = File.join(keys, "srv-gluster-01" + '.pem')
      salt.minion_pub = File.join(keys, "srv-gluster-01" + '.pub')
      salt.seed_master = {
                          "srv-gluster-01" => File.join(keys, 'srv-gluster-01.pub'),
                          "srv-gluster-02" => File.join(keys, 'srv-gluster-02.pub'),
                          "srv-docker-01" => File.join(keys, 'srv-docker-01.pub'),
                          "srv-docker-02" => File.join(keys, 'srv-docker-02.pub'),
                          "srv-docker-03" => File.join(keys, 'srv-docker-03.pub')
                         }
      salt.install_type = "stable"
      salt.install_master = true
      salt.no_minion = false
      salt.verbose = true
      salt.colorize = true
      salt.bootstrap_options = "-P -c /tmp"
    end

    node.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 1024]
      v.customize ["modifyvm", :id, "--cpus", 2]

      # add second disk for bricks
      diskfile = File.join(machine_folder, "srv-gluster-01", 'disk2.vdi')
      # Create and attach disk
      unless File.exist?(diskfile)
        v.customize ['createhd', '--filename', diskfile, '--format', 'VDI', '--size', 50 * 1024]
      end
      v.customize ['storagectl', :id, '--name', 'SATA Controller', '--portcount', 2]
      v.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', diskfile]
    end
  end

  ## setup srv-gluster-02
  config.vm.define "srv-gluster-02" do |node|
    node.vm.box = "debian/jessie64"
    node.vm.hostname = "srv-gluster-02"

    node.vm.network :private_network, ip: "192.168.56.102"
    
    node.vm.provision :salt do |salt|
      salt.minion_config = File.join(etc, 'minion')
      salt.grains_config = File.join(grains, "srv-gluster-02")
      salt.minion_key = File.join(keys, "srv-gluster-02" + '.pem')
      salt.minion_pub = File.join(keys, "srv-gluster-02" + '.pub')
      salt.install_type = "stable"
      salt.verbose = true
      salt.colorize = true
      salt.bootstrap_options = "-P -c /tmp"
    end

    node.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 1024]
      v.customize ["modifyvm", :id, "--cpus", 2]

      # add second disk for bricks
      diskfile = File.join(machine_folder, "srv-gluster-02", 'disk2.vdi')
      # Create and attach disk
      unless File.exist?(diskfile)
        v.customize ['createhd', '--filename', diskfile, '--format', 'VDI', '--size', 50 * 1024]
      end
      v.customize ['storagectl', :id, '--name', 'SATA Controller', '--portcount', 2]
      v.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', diskfile]
    end
  end

## setup 3 docker engines
  config.vm.define "srv-docker-01" do |node|
    node.vm.box = "debian/jessie64"
    node.vm.hostname = "srv-docker-01"

    node.vm.network :private_network, ip: "192.168.56.111"
    
    node.vm.provision :salt do |salt|
      salt.minion_config = File.join(etc, 'minion')
      salt.grains_config = File.join(grains, "srv-docker-01")
      salt.minion_key = File.join(keys, "srv-docker-01" + '.pem')
      salt.minion_pub = File.join(keys, "srv-docker-01" + '.pub')
      salt.install_type = "stable"
      salt.verbose = true
      salt.colorize = true
      salt.bootstrap_options = "-P -c /tmp"
    end

    node.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 512]
      v.customize ["modifyvm", :id, "--cpus", 1]

      # add second disk for bricks
      diskfile = File.join(machine_folder, "srv-docker-01", 'disk2.vdi')
      # Create and attach disk
      unless File.exist?(diskfile)
        v.customize ['createhd', '--filename', diskfile, '--format', 'VDI', '--size', 50 * 1024]
      end
      v.customize ['storagectl', :id, '--name', 'SATA Controller', '--portcount', 2]
      v.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', diskfile]
    end
  end

  config.vm.define "srv-docker-02" do |node|
    node.vm.box = "debian/jessie64"
    node.vm.hostname = "srv-docker-02"

    node.vm.network :private_network, ip: "192.168.56.112"
    
    node.vm.provision :salt do |salt|
      salt.minion_config = File.join(etc, 'minion')
      salt.grains_config = File.join(grains, "srv-docker-02")
      salt.minion_key = File.join(keys, "srv-docker-02" + '.pem')
      salt.minion_pub = File.join(keys, "srv-docker-02" + '.pub')
      salt.install_type = "stable"
      salt.verbose = true
      salt.colorize = true
      salt.bootstrap_options = "-P -c /tmp"
    end

    node.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 512]
      v.customize ["modifyvm", :id, "--cpus", 1]

      # add second disk for bricks
      diskfile = File.join(machine_folder, "srv-docker-02", 'disk2.vdi')
      # Create and attach disk
      unless File.exist?(diskfile)
        v.customize ['createhd', '--filename', diskfile, '--format', 'VDI', '--size', 50 * 1024]
      end
      v.customize ['storagectl', :id, '--name', 'SATA Controller', '--portcount', 2]
      v.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', diskfile]
    end
  end

  config.vm.define "srv-docker-03" do |node|
    node.vm.box = "debian/jessie64"
    node.vm.hostname = "srv-docker-03"

    node.vm.network :private_network, ip: "192.168.56.113"
    
    node.vm.provision :salt do |salt|
      salt.minion_config = File.join(etc, 'minion')
      salt.grains_config = File.join(grains, "srv-docker-03")
      salt.minion_key = File.join(keys, "srv-docker-03" + '.pem')
      salt.minion_pub = File.join(keys, "srv-docker-03" + '.pub')
      salt.install_type = "stable"
      salt.verbose = true
      salt.colorize = true
      salt.bootstrap_options = "-P -c /tmp"
    end

    node.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 512]
      v.customize ["modifyvm", :id, "--cpus", 1]

      # add second disk for bricks
      diskfile = File.join(machine_folder, "srv-docker-03", 'disk2.vdi')
      # Create and attach disk
      unless File.exist?(diskfile)
        v.customize ['createhd', '--filename', diskfile, '--format', 'VDI', '--size', 50 * 1024]
      end
      v.customize ['storagectl', :id, '--name', 'SATA Controller', '--portcount', 2]
      v.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', diskfile]
    end
  end


end