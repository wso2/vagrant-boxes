# Vagrant box genration for WSO2 products

This section defines the procedure to build Vagrant boxes required for WSO2 Products

Please note that in order to build these Vagrant boxes, you need to install
[Oracle VM VirtualBox](http://www.oracle.com/technetwork/server-storage/virtualbox/downloads/index.html),
as WSO2 Vagrant resources use Oracle VM VirtualBox, as the default provider.

Virtualization should be enabled in the BIOS before building the boxes.
## How to build the Vagrant boxes


### Vagrant box build process


1. Checkout this repository into your local machine using the following Git command.
```
git clone https://github.com/wso2/vagrant-boxes.git
```

2. Download

i. WSO2 API Manager 2.1.0

[WSO2 API Manager 2.1.0](https://wso2.com/api-management/#download), [JDK 8u144-linux-x64.tar](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html), [MySQL Connector/J](https://dev.mysql.com/downloads/connector/j/) and [WSO2 Update Manager](https://wso2.com/wum/download). Copy them to the following path.

ii. WSO2 Enterprise Integrator 6.1.1

[WSO2 Enterprise Integrator 6.1.1](https://wso2.com/integration#download), [JDK 8u144-linux-x64.tar](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html), [MySQL Connector/J](https://dev.mysql.com/downloads/connector/j/) and [WSO2 Update Manager](https://wso2.com/wum/download). Copy them to the following path.

iii. WSO2 Identity Server 5.4.1

 [WSO2 Identity Server 5.4.1](https://wso2.com/identity-and-access-management#download), [JDK 8u144-linux-x64.tar](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html), [MySQL Connector/J](https://dev.mysql.com/downloads/connector/j/) and [WSO2 Update Manager](https://wso2.com/wum/download). Copy them to the following path.

Note: Adding WSO2 Update Manager is optional. Read more about [WSO2 Update Manager](https://wso2.com/wum/).
```
~/files/
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
		provisioner_script: mysql/provisioner/provisioner.sh

	-
		output_box: wso2am
		base_box: ubuntu/trusty64
		ip: 172.28.128.4
		provisioner_script: provisioner/provisioner.sh
		provisioner_script_args:
			- server: wso2am
			- version: 2.1.0
	-
		output_box: wso2am-analytics
		base_box: ubuntu/trusty64
		ip: 172.28.128.5
		provisioner_script: provisioner/provisioner.sh
		provisioner_script_args:
			- server: wso2am-analytics
			- version: 2.1.0
```
WSO2 Enterprise Integrator 6.1.1
```
---
boxes:
	-
		output_box: mysql
		base_box: ubuntu/trusty64
		ip: 172.28.128.3
		provisioner_script: mysql/provisioner/provisioner.sh

	-
		output_box: wso2ei
		base_box: ubuntu/trusty64
		ip: 172.28.128.4
		provisioner_script: provisioner/provisioner.sh
		provisioner_script_args:
			- server: wso2ei
			- version: 6.1.1
```
WSO2 Identity Server 5.4.1
```
---
boxes:
	-
		output_box: mysql
		base_box: ubuntu/trusty64
		ip: 172.28.128.3
		provisioner_script: mysql/provisioner/provisioner.sh

	-
		output_box: wso2is
		base_box: ubuntu/trusty64
		ip: 172.28.128.4
		provisioner_script: provisioner/provisioner.sh
		provisioner_script_args:
			- server: wso2is
			- version: 5.4.1
	-
		output_box: wso2is-analytics
		base_box: ubuntu/trusty64
		ip: 172.28.128.5
		provisioner_script: provisioner/provisioner.sh
		provisioner_script_args:
			- server: wso2is-analytics
			- version: 5.4.1
```

4. Execute the build.sh shell script.
```
./build.sh
```
5. Add created box files to local Vagrant box cache.

The created box files can be found in the output directory. In order to add a created box to the local Vagrant box cache use the `vagrant box add` command.

```
vagrant box add <BOX_NAME> <BOX_FILE_PATH>
```

An example for adding the created WSO2 API Manager Vagrant box file (by default, defined
within the `config.yaml` file) is as follows:

```
vagrant box add wso2am output/wso2am.box
```
