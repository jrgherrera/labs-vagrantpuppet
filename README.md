# Vagrant + Puppet base 

This is the base configuration of the project, using Vagrant + Puppet.

## Requirements:

* Download and Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads).

* Download their Extension Pack [at the same link](https://www.virtualbox.org/wiki/Downloads).

* Download and Install [Vagrant](http://downloads.vagrantup.com/).

## Installation

Create a directory on the place that you want, and locate with the __Terminal__ application on it:

	mkdir new-directory/
    cd new-directory/

Clone the entire project.

    git clone --recursive git://github.com/hangarcr/PROJECT-NAME.git .

If you are Tech Leader just clone this repository and put the files on _"project"_ directory, delete the file "delete-this-file" and delete all __.git__ directories to start a new repository.

    git clone --recursive git@github.com:hangarcr/labs-vagrantpuppet.git .
    rm project/delete-this-file
    rm -rf .git

Locate the file called _Vagrantfile_ and make sure that you are at the same level.

Start vagrant:

    vagrant up

If you want to create an alias, just open your _/etc/hosts_ file and add a new entry.

    192.168.100.100    project.dev

__Note:__ If you don't know what is the IP, just open the file _Vagrantfile_ and locate the line

      config.vm.network :private_network, ip: "192.168.100.100"
