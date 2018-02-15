# Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
# limitations under the License.

# -*- mode: ruby -*-

require 'yaml'
require 'fileutils'

# load server configurations from YAML file
CONFIGURATIONS = YAML.load_file('config.yaml')
# create an empty array to hold box names
boxnames=Array.new

# loop through each box specification
CONFIGURATIONS['boxes'].each do |box|
  # add box name to array of box names
  boxnames.push box['output_box']
end

puts boxnames
