# Vagrant + Puppet base 

This is the base configuration of the project, using Vagrant + Puppet.

Vagrant version: 1.6.3

## Requirements:

* Download and Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads).

* Download their Extension Pack [at the same link](https://www.virtualbox.org/wiki/Downloads).

* Download and Install [Vagrant](http://www.vagrantup.com/downloads.html).

* Download and Install [Vagrant Hostupdater](https://github.com/cogitatio/vagrant-hostsupdater).

## Installation

To install Vagrant Hostmaster just open __Terminal__ application and type:

    vagrant plugin install vagrant-hostsupdater

Give full permission to your __/etc/hosts__ file:

    sudo chmod 777 /etc/hosts

Create a directory on the place that you want, and locate with the __Terminal__ application on it:

    mkdir new-directory/
    cd new-directory/

### New project

Clone this repository and put the files on _"project"_ directory, delete the file "delete-this-file" and delete all __.git__ directories to start a new repository.

    git clone --recursive https://github.com/hangarcr/labs-vagrantpuppet .
    rm -rf .git

Locate the file called _Vagrantfile_ and make sure that you are at the same level.

Start vagrant:

    vagrant up

## Notes

You can edit the IP value and the Host name, just open __Vagrantfile__ and edit the following lines:

    config.vm.network :private_network, ip: "192.168.10.11"
    config.vm.hostname = "labs-vagrantpuppet.dev"

If you want to restore an existing database dump, just place the .sql file on __vagrant-data/modules/mysql/files/__ with the name __backup.sql__.