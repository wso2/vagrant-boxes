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

#!/bin/bash

WSO2_SERVER=$1
WSO2_SERVER_VERSION=$2
WSO2_SERVER_PACK=${WSO2_SERVER}-${WSO2_SERVER_VERSION}*.zip
JDK_ARCHIVE=jdk-8u*-linux-x64.tar.gz
MYSQL_CONNECTOR=mysql-connector-java-5.1.*-bin.jar
DEFAULT_MOUNT=/vagrant
SOFTWARE_DISTRIBUTIONS=${DEFAULT_MOUNT}/files
CONFIGURATIONS=${DEFAULT_MOUNT}/identity-server/confs
WORKING_DIRECTORY=/home/vagrant
JAVA_HOME=/opt/java
DEFAULT_USER=vagrant

# operate in anti-fronted mode with no user interaction
export DEBIAN_FRONTEND=noninteractive

# check if the required software distributions have been added
if [ ! -f ${SOFTWARE_DISTRIBUTIONS}/${WSO2_SERVER_PACK} ]; then
    echo "WSO2 server pack not found. Please copy the ${WSO2_SERVER_PACK} to ${SOFTWARE_DISTRIBUTIONS} folder and retry."
    exit 1
fi

if [ ! -f ${SOFTWARE_DISTRIBUTIONS}/${JDK_ARCHIVE} ]; then
    echo "JDK archive file not found. Please copy the JDK archive file to ${SOFTWARE_DISTRIBUTIONS} folder and retry."
    exit 1
fi

if [ ! -f ${SOFTWARE_DISTRIBUTIONS}/${MYSQL_CONNECTOR} ]; then
    echo "MySQL Connector JAR file not found. Please copy the MySQL Connector JAR file to ${SOFTWARE_DISTRIBUTIONS} folder and retry."
    exit 1
fi

echo "Starting the ${WSO2_SERVER}-${WSO2_SERVER_VERSION} Vagrant box build process..."

# install utility software
echo "Installing software utilities..."
apt-get install unzip
echo "Successfully installed software utilities"

# set up Java
echo "Setting up Java..."
if test ! -d ${JAVA_HOME}; then mkdir ${JAVA_HOME}; fi
if test -d ${JAVA_HOME}; then
  tar -xf ${SOFTWARE_DISTRIBUTIONS}/${JDK_ARCHIVE} -C ${JAVA_HOME} --strip-components=1
fi
echo "Successfully set up Java"

# moving the WSO2 product pack to the working directory
echo "Moving the ${WSO2_SERVER_PACK} to the directory: ${WORKING_DIRECTORY}..."
if test ! -d ${WSO2_SERVER}-${WSO2_SERVER_VERSION}; then
  mv ${SOFTWARE_DISTRIBUTIONS}/${WSO2_SERVER_PACK} ${WORKING_DIRECTORY}
  echo "Successfully moved ${WSO2_SERVER_PACK} to ${WORKING_DIRECTORY}"
fi

# add the MySQL driver
echo "Copying the MySQL driver to the ${WORKING_DIRECTORY}"
cp ${SOFTWARE_DISTRIBUTIONS}/${MYSQL_CONNECTOR} ${WORKING_DIRECTORY}
echo "Successfully copied the MySQL driver to the server pack."

# set ownership of the working directory to the default ssh user and group
chown -R ${DEFAULT_USER}:${DEFAULT_USER} ${WORKING_DIRECTORY}

# remove the APT cache
apt-get clean
if [ "$?" -eq "0" ];
then
  echo "Successfully removed APT cache"
else
  echo "Failed to remove APT cache"
fi

# zero out the drive
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# clear the bash history and exit
cat /dev/null > ${WORKING_DIRECTORY}/.bash_history && history -c
