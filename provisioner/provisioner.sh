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
WSO2_SERVER_UPDATED_PACK=${WSO2_SERVER}-${WSO2_SERVER_VERSION}.*.zip
WUM_ARCHIVE=wum-1.0-linux-x64.tar.gz
WORKING_DIRECTORY=/home/vagrant
WUM_HOME=/usr/local/
WUM_PATH='PATH=$PATH:/usr/local/wum/bin'
WUM_PRODUCT_LOCATION=/root/.wum-wso2/products/${WSO2_SERVER}/${WSO2_SERVER_VERSION}


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
wum update
mv ${WUM_PRODUCT_LOCATION}/${WSO2_SERVER_UPDATED_PACK} ${WORKING_DIRECTORY}/${WSO2_SERVER_PACK}
rm -rf /root/.wum-wso2/congif.yaml
rm -rf /root/.wum-wso2/updates
rm -rf ${WUM_PRODUCT_LOCATION}/${WSO2_SERVER_PACK}

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

# clear the bash history and exit
cat /dev/null > ${WORKING_DIRECTORY}/.bash_history && history -c
