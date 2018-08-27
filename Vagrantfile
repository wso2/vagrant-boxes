# Copyright 2018 WSO2, Inc. (http://wso2.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License

require 'yaml'
require 'fileutils'
require 'uri'
require 'erb'

# check whether the command is 'vagrant up'
if ARGV[0] == 'up'
  print "Please insert your WSO2 credentials\n"
  print "Username: "
  USERNAME = "424042605@qq.com"
  print "Password: "
  PASSWORD = "Xx713193*Gg2"
  print "\n"
else
  # initializing USERNAME and PASSWORD
  USERNAME = ""
  PASSWORD = ""
end

FILES_PATH = "./files/"
JDK_ARCHIVE = "jdk-8u181-linux-x64.tar.gz"
MYSQL_CONNECTOR = "mysql-connector-java-5.1.47-bin.jar"
WUM_ARCHIVE = "wum-3.0.1-linux-x64.tar.gz"
DEFAULT_MOUNT = "/home/vagrant/"

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

CONFIGURATIONS = YAML.load_file('config.yaml')

Vagrant.configure("2") do |config|
  # changing default timeout from 300 to 1000 seconds
  config.vm.boot_timeout = 1000
  # going through each server configuratioin specification
  CONFIGURATIONS['boxes'].each do |box|
    # define the vm configuration
    config.vm.define box['output_box'] do |server_config|
      # define the base vagrant box to be used
      server_config.vm.box = box['base_box']
      # define the host name
      server_config.vm.host_name = box['output_box']

      # Diasbling the synched folder
      server_config.vm.synced_folder ".", "/vagrant", disabled: true

      # set the network configurations for the vm
      server_config.vm.network :private_network,ip: box['ip']

      #forwarding ports to access the server via localhost
      if box['ports']
        box['ports'].each do |port|
          server_config.vm.network "forwarded_port", guest: port, host: port, guest_ip: box['ip']
        end
      end

      memory = 2048
      cpu = 1

      server_config.vm.provider :virtualbox do |vb|
        vb.name = box['output_box_name']
        vb.check_guest_additions = true
        vb.functional_vboxsf = false
        vb.gui = false
        vb.customize ['modifyvm', :id, '--memory', memory]
        vb.customize ['modifyvm', :id, '--cpus', cpu]
      end

      # add the resources to the boxes
      if box['resources']
        server_config.vm.provision "file", source: FILES_PATH + JDK_ARCHIVE, destination: DEFAULT_MOUNT + JDK_ARCHIVE
        server_config.vm.provision "file", source: FILES_PATH + MYSQL_CONNECTOR, destination: DEFAULT_MOUNT + MYSQL_CONNECTOR
        server_config.vm.provision "file", source: FILES_PATH + WUM_ARCHIVE, destination: DEFAULT_MOUNT + WUM_ARCHIVE
        box['resources'].each do |resource|
          source = FILES_PATH + resource
          server_config.vm.provision "file", source: source, destination: DEFAULT_MOUNT + resource
        end
      end
      # run the provisioner to get the latest pack
      if box['provisioner_script_args']
        server = box['provisioner_script_args'][0]['server']
        version = box['provisioner_script_args'][1]['version']
        server_config.vm.provision "shell", path: box["provisioner_script"], args: [server, version, USERNAME, PASSWORD]
      else
        server_config.vm.provision "shell", path: box["provisioner_script"]
      end
    end
  end
end
