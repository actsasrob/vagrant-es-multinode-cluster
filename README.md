# vagrant-es-multinode-cluster
vagrant project to create VMs for a multinode elasticsearch cluster.

This vagrant project creates the elasticsearch servers (multiple master, ingest, data) and a Kibana server running on CentOS7.

Elasticsearch and kibana are installed via the Ansible playbooks found here: (https://github.com/actsasrob/ansible-plays)


## Setup instructions:
To use this project:
1. Install VirtualBox (tested with v5.1.36)
1. Install Vagrant (tested with Vagrant 1.9.3)
1. Git clone this project: `git clone git@github.com:actsasrob/vagrant-es-multinode-cluster.git`
1. Edit Vagrantfile to contain the desired number of master, ingest, data nodes
1. Run `vagrant up` to create the servers
1. Install Ansible
1. From Ansible Galaxy install role geerlingguy.kibana: `ansible-galaxy install geerlingguy.kibana`
1. Update geerlingguy.kibana/templates/kibana.repo.j2
    ```[kibana-6.x]
    name=Kibana repository for 6.x packages
    baseurl=https://artifacts.elastic.co/packages/6.x/yum
    gpgcheck=1
    gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
    enabled=1
    autorefresh=1
    type=rpm-md
    ```
1. From Ansible Galaxy install role elastic.elasticsearch: `ansible-galaxy install elastic.elasticsearch`
1. Git clone the Ansible playbooks: `git clone git@github.com:actsasrob/ansible-plays.git` 
1. Edit the <path to ansible-plays dir>/inventory/es01.ini file and change the ansible_ssh_private_key_file line to point to where the vagrant-es-multinode-cluster dir lives
1. To install elasticsearch on the vagrant nodes run the playbook:  `ansible-playbook -i <path to ansible-plays dir>/inventory/es01.ini <path to ansible-plays dir>/plays/es-provision.yml`
1. To install kibana on the Kibana server run the playbook: `ansible-playbook -i <path to ansible-plays dir>/inventory/es01.ini <path to ansible-plays dir>/plays/lk-provision.yml`
