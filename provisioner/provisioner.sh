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

# This script acts as the machine provisioner during the Vagrant box build process for WSO2 Identity Server.

# set variables
WSO2_SERVER=$1
WSO2_SERVER_VERSION=$2
USERNAME=$3
PASSWORD=$4
WSO2_SERVER_PACK=${WSO2_SERVER}-${WSO2_SERVER_VERSION}.zip
WSO2_SERVER_UPDATED_PACK=${WSO2_SERVER}-${WSO2_SERVER_VERSION}*.full.zip
WUM_ARCHIVE=wum-3.0.5-linux-x64.tar.gz
WORKING_DIRECTORY=/home/vagrant
WUM_HOME=/usr/local/
WUM_PATH='PATH=$PATH:/usr/local/wum/bin'
WUM_PRODUCT_LOCATION=/root/.wum3/products/${WSO2_SERVER}/${WSO2_SERVER_VERSION}

# operate in anti-fronted mode with no user interaction
export DEBIAN_FRONTEND=noninteractive

# check if the required software distributions have been added
if [ ! -f ${WORKING_DIRECTORY}/${WSO2_SERVER_PACK} ]; then
    echo "WSO2 server pack not found. Please copy the ${WSO2_SERVER_PACK} to ${WORKING_DIRECTORY} folder and retry."
    exit 1
fi

if [ ! -f ${WORKING_DIRECTORY}/${WUM_ARCHIVE} ]; then
    echo "WUM archive file not found. Please copy the JDK archive file to ${WORKING_DIRECTORY} folder and retry."
    exit 1
fi

# set up wum
echo "Setting up WUM."
if test ! -d ${WUM_HOME}; then
  mkdir ${WUM_HOME};
fi
tar -xf ${WORKING_DIRECTORY}/${WUM_ARCHIVE} -C ${WUM_HOME} --strip-components=1
echo "Successfully set up WUM."

export WUM_PATH

echo "Getting the ${WSO2_SERVER}-${WSO2_SERVER_VERSION} latest pack."
wum init -u ${USERNAME} -p ${PASSWORD}
wum add --file ${WORKING_DIRECTORY}/${WSO2_SERVER_PACK}
wum update ${WSO2_SERVER}-${WSO2_SERVER_VERSION}

if [ ! -f ${WUM_PRODUCT_LOCATION}/full/${WSO2_SERVER_UPDATED_PACK} ]; then
  echo "No updated pack. Use the GA pack instead."
else
  echo "moving updated product pack to ${WORKING_DIRECTORY}"
  mv ${WUM_PRODUCT_LOCATION}/full/${WSO2_SERVER_UPDATED_PACK} ${WORKING_DIRECTORY}/${WSO2_SERVER_PACK}
fi

echo "removing common wum user credentails"
sed -i "s/username:.*/username:/" /root/.wum3/config.yaml
sed -i "s/refreshtoken:.*/refreshtoken:/" /root/.wum3/config.yaml
sed -i "s/accesstoken:.*/accesstoken:/" /root/.wum3/config.yaml
echo "wum credentials and app keys removed Successfully"

echo "Removing unnecessary files."
rm -rf /root/.wum3/updates
rm -rf ${WUM_PRODUCT_LOCATION}/
rm -rf ${WUM_ARCHIVE}
rm -rf /tmp/wum*
ls -lh
echo "Removing unnecessary files finished Successfully."

# set ownership of the working directory to the default ssh user and group
chown -R ${DEFAULT_USER}:${DEFAULT_USER} ${WORKING_DIRECTORY}

# remove the APT cache
apt-get clean
if [ "$?" -eq "0" ];
then
  echo "Successfully removed APT cache."
else
  echo "Failed to remove APT cache."
fi
# Zero free space to aid VM compression
dd if=/dev/zero of=/EMPTY bs=1M | true
rm -f /EMPTY

# Remove bash history
unset HISTFILE
rm -f /root/.bash_history
rm -f /home/vagrant/.bash_history

# Cleanup log files
find /var/log -type f | while read f; do echo -ne '' > $f; done;

# clear the bash history and exit
cat /dev/null > ${WORKING_DIRECTORY}/.bash_history && history -c
