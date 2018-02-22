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

   iii. WSO2 Enterprise Integrator 6.1.1

      [WSO2 Enterprise Integrator 6.1.1](https://wso2.com/integration#download).

   iv. WSO2 Identity Server 5.4.1

      [WSO2 Identity Server 5.4.1](https://wso2.com/identity-and-access-management#download).

   iv. Stream Processor 4.0.0

      [WSO2 Stream Processor 4.0.0](https://wso2.com/analytics#download).

   vi. Copy them to the following path

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
    resources:
      - wso2am-2.1.0.zip
  -
    output_box: wso2am-analytics
    base_box: ubuntu/trusty64
    ip: 172.28.128.5
    resources:
      - wso2am-analytics-2.1.0.zip
```
WSO2 Enterprise Integrator 6.1.1
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
    resources:
      - wso2ei-6.1.1.zi
```
WSO2 Identity Server 5.4.1
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
    resources:
      - wso2is-5.4.1.zip
  -
    output_box: wso2is-analytics
    base_box: ubuntu/trusty64
    ip: 172.28.128.5
    resources:
      - wso2is-analytics-5.4.1.zip
```
Stream Processor 4.0.0
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
      - wso2sp-4.0.0.zip
      - kafka_2.11_0.10.0.0_1.0.0.jar
      - kafka_clients_0.10.0.0_1.0.0.jar
      - metrics_core_2.2.0_1.0.0.jar
      - scala_library_2.11.8_1.0.0.jar
      - scala_parser_combinators_2.11_1.0.4_1.0.0.jar
      - zkclient_0.8_1.0.0.jar
      - zookeeper_3.4.6_1.0.0.jar
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
