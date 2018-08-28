# Vagrant box generation for WSO2 products

This section defines the procedure to build Vagrant boxes required for WSO2 Products

## How to build the Vagrant boxes

### Prerequisites

Please note that in order to build these Vagrant boxes, you need to install
[Oracle VM VirtualBox](http://www.oracle.com/technetwork/server-storage/virtualbox/downloads/index.html),
as WSO2 Vagrant resources use Oracle VM VirtualBox, as the default provider.

Virtualization should be enabled in the BIOS before building the boxes.

### Vagrant box build process


1. Checkout this repository into your local machine using the following Git command.
```
git clone https://github.com/wso2/vagrant-boxes.git
```
The local copy of the `vagrant-boxes` directory will be referred to as `VAGARNT-BOXES_HOME` from this point onwards.

2. Download

   i. JDK, MySQL Connector, WSO2 Update Manager

      [JDK 8u144-linux-x64.tar](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html), [MySQL Connector/J](https://dev.mysql.com/downloads/connector/j/) and [WSO2 Update Manager](https://wso2.com/wum/download).

   ii. WSO2 API Manager 2.1.0

      [WSO2 API Manager 2.1.0](https://wso2.com/api-management/#download).

   iii. WSO2 Enterprise Integrator 6.2.0

      [WSO2 Enterprise Integrator 6.2.0](https://wso2.com/integration#download).

   iv. WSO2 Identity Server 5.5.0

      [WSO2 Identity Server 5.5.0](https://wso2.com/identity-and-access-management#download).

   v. Stream Processor 4.1.0

      [WSO2 Stream Processor 4.1.0](https://wso2.com/analytics#download).

   vi. IoT Server 3.3.0

      [WSO2 IoT Server 3.3.0](https://wso2.com/iot#download).

   vii. Copy them to the following path

Note: Adding WSO2 Update Manager is optional. Read more about [WSO2 Update Manager](https://wso2.com/wum/).

```
<VAGARNT-BOXES_HOME>/files/
```
3. Edit the config.yaml as required (Comment out the unnecessary box entries).

WSO2 API Manager 2.1.0
```
---
boxes:
  -
    output_box: mysql
    base_box: ubuntu/trusty64
    ip: 172.28.128.3
    provisioner_script: mysql-provisioner/provisioner.sh
  -
    output_box: wso2am
    base_box: ubuntu/trusty64
    ip: 172.28.128.4
    ports:
      - 9443
      - 8280
      - 8243
    resources:
      - wso2am-2.1.0.zip
    provisioner_script: provisioner/provisioner.sh
    provisioner_script_args:
      - server: wso2am
      - version: 2.2.0
  -
    output_box: wso2am-analytics
    base_box: ubuntu/trusty64
    ip: 172.28.128.5
    resources:
      - wso2am-analytics-2.2.0.zip
    provisioner_script: provisioner/provisioner.sh
    provisioner_script_args:
      - server: wso2am-analytics
      - version: 2.2.0
  -
    output_box: wso2is-as-km
    base_box: ubuntu/trusty64
    ip: 172.28.128.6
    resources:
      - wso2is-km-5.5.0.zip
    provisioner_script: provisioner/provisioner.sh
    provisioner_script_args:
      - server: wso2is-as-km
      - version: 5.5.0
  -
    output_box: wso2am-micro-gw
    base_box: ubuntu/trusty64
    ip: 172.28.128.7
    resources:
      - wso2am-micro-gw-2.2.0.zip
    provisioner_script: provisioner/provisioner.sh
    provisioner_script_args:
      - server: wso2am-micro-gw
      - version: 2.2.0

```
WSO2 Enterprise Integrator 6.2.0
```
---
boxes:
  -
    output_box: mysql
    base_box: ubuntu/trusty64
    ip: 172.28.128.3
    provisioner_script: mysql-provisioner/provisioner.sh
  -
    output_box: wso2ei
    base_box: ubuntu/trusty64
    ip: 172.28.128.4
    ports:
      - 9444
    resources:
      - wso2ei-6.2.0.zip
    provisioner_script: provisioner/provisioner.sh
    provisioner_script_args:
      - server: wso2ei
      - version: 6.2.0

```
WSO2 Identity Server 5.5.0
```
---
boxes:
  -
    output_box: mysql
    base_box: ubuntu/trusty64
    ip: 172.28.128.3
    provisioner_script: mysql-provisioner/provisioner.sh
  -
    output_box: wso2is
    base_box: ubuntu/trusty64
    ip: 172.28.128.4
    ports:
      - 9443
    resources:
      - wso2is-5.5.0.zip
    provisioner_script: provisioner/provisioner.sh
    provisioner_script_args:
      - server: wso2is
      - version: 5.5.0
  -
    output_box: wso2is-analytics
    base_box: ubuntu/trusty64
    ip: 172.28.128.5
    ports:
      - 9444
    resources:
      - wso2is-analytics-5.5.0.zip
    provisioner_script: provisioner/provisioner.sh
    provisioner_script_args:
      - server: wso2is-analytics
      - version: 5.5.0
```
Stream Processor 4.1.0
```
---
boxes:
  -
    output_box: mysql
    base_box: ubuntu/trusty64
    ip: 172.28.128.3
    provisioner_script: mysql-provisioner/provisioner.sh
  -
    output_box: wso2sp
    base_box: ubuntu/trusty64
    ip: 172.28.128.4
    resources:
      - wso2sp-4.1.0.zip
    provisioner_script: provisioner/provisioner.sh
    provisioner_script_args:
      - server: wso2sp
      - version: 4.1.0
```
IoT Server 3.3.0
```
---
boxes:
  -
    output_box: mysql
    base_box: ubuntu/trusty64
    ip: 172.28.128.3
    provisioner_script: mysql-provisioner/provisioner.sh
  -
    output_box: wso2iot
    base_box: ubuntu/trusty64
    ip: 172.28.128.5
    ports:
      - 9443
    resources:
      - wso2iot-3.3.0.zip
    provisioner_script: provisioner/provisioner.sh
    provisioner_script_args:
      - server: wso2iot
      - version: 3.3.0
```

4. Run the Vagrantfile.
```
vagrant up
```

5. Create the boxes.
```
vagrant package $box --output output/$box.box
```
An example for compressing the created WSO2 API Manager Vagrant machine file is as follows:

```
vagrant package wso2am --output output/wso2am.box
```

6. Add created box files to local Vagrant box cache.

The created box files can be found in the output directory. In order to add a created box to the local Vagrant box cache use the `vagrant box add` command.

```
vagrant box add <BOX_NAME> <BOX_FILE_PATH>
```

An example for adding the created WSO2 API Manager Vagrant box file (by default, defined
within the `config.yaml` file) is as follows:

```
vagrant box add wso2am output/wso2am.box
```
