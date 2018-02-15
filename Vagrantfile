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

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
CONFIGURATIONS = YAML.load_file('config.yaml')

Vagrant.configure("2") do |config|
  # going through each server configuratioin specification
  CONFIGURATIONS['boxes'].each do |box|
  # define the vm configuration
  config.vm.define box['output_box'] do |server_config|
    # define the base vagrant box to be used
    server_config.vm.box = box['base_box']
    # define the host name
    server_config.vm.host_name = box['output_box']

    # set the network configurations for the vm
    server_config.vm.network :private_network,ip: box['ip']
    memory = 2048
    cpu = 1

    server_config.vm.provider :virtualbox do |vb|
      vb.name = box['output_box_name']
      vb.check_guest_additions = false
      vb.functional_vboxsf = false
      vb.gui = false
      vb.customize ['modifyvm', :id, '--memory', memory]
      vb.customize ['modifyvm', :id, '--cpus', cpu]
    end

    # configure shell provisioner
      if box['provisioner_script_args']
        # if argument(s) have been defined to be passed to the shell script
        server_config.vm.provision "shell", path: box["provisioner_script"], args: box["provisioner_script_args"]
      else
        # if no argument(s) have been defined to be passed to the shell script
        server_config.vm.provision "shell", path: box["provisioner_script"]
      end
    end
  end
end
