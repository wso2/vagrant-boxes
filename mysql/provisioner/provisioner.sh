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

# This script acts as the machine provisioner during the Vagrant box build process for MySQL database service.

# set variables
DB_PASSWORD=wso2carbon
WORKING_DIRECTORY=/home/vagrant

# set and export environment variables
export DEBIAN_FRONTEND=noninteractive
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# set MySQL root password configuration using debconf
echo debconf mysql-server/root_password password $DB_PASSWORD | \
  sudo debconf-set-selections
echo debconf mysql-server/root_password_again password $DB_PASSWORD | \
  sudo debconf-set-selections

# run package updates
apt-get update

# install mysql
apt-get -y install mysql-server

# set the bind address from loopback address to all IPv4 addresses of the host
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mysql/my.cnf

# restart the MySQL server
service mysql restart

# remove the APT cache
apt-get clean

# zero out the drive
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# clear the bash history and exit
cat /dev/null > ${WORKING_DIRECTORY}/.bash_history && history -c
