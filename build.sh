#!/bin/bash

# ------------------------------------------------------------------------
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
# ------------------------------------------------------------------------

# This script acts as the Vagrant box build process manager.

# spawn the Vagrant machines based on the server specifications provided in config.yaml
vagrant up

# load box names from definitions
OUTPUT=$(ruby box_definitions.rb)

echo $OUTPUT

# loop through all defined box names and create box files
for box in ${OUTPUT}
do
    vagrant package $box --output output/$box.box
done

vagrant destroy -f
