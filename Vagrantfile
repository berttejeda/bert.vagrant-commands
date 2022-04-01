# -*- mode: ruby -*-
# vi: set ft=ruby :

# Load custom libraries
require 'config/reader'

# Specify minimum Vagrant/Vagrant API version
Vagrant.require_version "#{$vagrant.require_version}"

# Define Virtual Machines
Vagrant.configure($vagrant.api_version) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "private_network", ip: "192.168.33.10"
end