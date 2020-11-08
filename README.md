# VBOX Provisioner

Auto provisioning of Linux configured Virtualbox servers that are ready to run Docker and Kuberneties.

# Step 1
```
$ ./create_centos7_vm.sh
```
# Step 2
```
$ VBoxManage startvm cl-02 --type=headless
```
# Step 3
```
$ VBoxManage showvminfo c7-02 --machinereadable | grep macaddress1
```
# Step 4
```
$ sudo arp-scan --interface=vboxnet0 --localnet
````
