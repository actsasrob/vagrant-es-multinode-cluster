# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
Vagrant.require_version ">= 1.5.2"

$centos_es_setupscript = <<END

  # Install for VBoxGuestAdditons
  #yum -y install epel-release
  #yum install -y gcc kernel-devel kernel-headers dkms make bzip2 perl
  #export KERN_DIR=/usr/src/kernels/`uname -r`/build

  # Hardlock domain name
  echo 'supercede domain-name "co";' > /etc/dhcp/dhclient.conf

  #echo "info: disable SELinux"
  #sed -i -e 's/^SELINUX=.*/SELINUX=disabled/' /etc/sysconfig/selinux 
  #setenforce 0

  echo "Check SELinux status..."
  getenforce

  # create ansible user and set up ssh keys
  UMASK=0022
  mkdir -p /usr/local/home
  useradd --comment "Ansible user" --create-home -U -G wheel --home-dir=/usr/local/home/ansible ansible
  mkdir /usr/local/home/ansible/.ssh
  cp /vagrant/keys/id_rsa /usr/local/home/ansible/.ssh
  cp /vagrant/keys/id_rsa.pub /usr/local/home/ansible/.ssh
  cat /vagrant/keys/id_rsa.pub >> /usr/local/home/ansible/.ssh/authorized_keys
  chmod 400 /usr/local/home/ansible/.ssh/id_rsa
  chown -R ansible.ansible /usr/local/home/ansible/

  sed -i "s/# %wheel/%wheel/" /etc/sudoers

  # Note: In order to install Oracle Java 8 JDK, you will need to go to the Oracle Java 8 JDK Downloads Page, accept the license agreement, and copy the download link of the appropriate Linux .rpm package. Substitute the copied download link in place of the highlighted part of the wget command.

  yum install -y wget net-tools

  whoami
END

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Create Master nodes
  NM = 2
  (1..NM).each do |machine_id|
    config.vm.define "es-m#{machine_id}" do |machine|
      machine.vm.box = "centos/7"
      machine.vm.hostname = "es-m#{machine_id}"
      machine.vm.network "private_network", ip: "192.168.77.#{20+machine_id}"
      machine.vm.provider :virtualbox do |vb|
         vb.memory = 3072 
         vb.cpus = 2
      end
      machine.vm.provision "shell", inline: $centos_es_setupscript
    end
  end

  # Create Ingest nodes
  NI = 1 
  (1..NI).each do |machine_id|
    config.vm.define "es-i#{machine_id}" do |machine|
      machine.vm.box = "centos/7"
      machine.vm.hostname = "es-i#{machine_id}"
      machine.vm.network "private_network", ip: "192.168.78.#{20+machine_id}"
      machine.vm.provider :virtualbox do |vb|
         vb.memory = 2048 
         vb.cpus = 2
      end
      machine.vm.provision "shell", inline: $centos_es_setupscript
    end
  end

  # Create Data nodes
  ND = 3
  (1..ND).each do |machine_id|
    config.vm.define "es-d#{machine_id}" do |machine|
      machine.vm.box = "centos/7"
      machine.vm.hostname = "es-d#{machine_id}"
      machine.vm.network "private_network", ip: "192.168.79.#{20+machine_id}"
      machine.vm.provider :virtualbox do |vb|
         vb.memory = 3072 
         vb.cpus = 2
      end
      machine.vm.provision "shell", inline: $centos_es_setupscript
    end
  end

  # Create Kibana server
  NK = 1
  (1..NK).each do |machine_id|
    config.vm.define "es-k#{machine_id}" do |machine|
      machine.vm.box = "centos/7"
      machine.vm.hostname = "es-k#{machine_id}"
      machine.vm.network "private_network", ip: "192.168.80.#{20+machine_id}"
      machine.vm.provider :virtualbox do |vb|
         vb.memory = 1024 
         vb.cpus = 2
      end
      machine.vm.provision "shell", inline: $centos_es_setupscript
    end
  end

end
