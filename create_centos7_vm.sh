VM='Centos-7-64-bit'
VBoxManage createhd --filename $VM.vdi --size 32768
VBoxManage createvm --name $VM --ostype "Redhat_64" --register
VBoxManage storagectl $VM --name "SATA Controller" --add sata --controller IntelAHCI
VBoxManage storageattach $VM --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $VM.vdi
VBoxManage storagectl $VM --name "IDE Controller" --add ide
VBoxManage storageattach $VM --storagectl "IDE Controller" --port 0 
VBoxManage storageattach $VM --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium /mnt/disk-1/shared/software/CentOS-7-x86_64-DVD-1810.iso
VBoxManage modifyvm $VM --ioapic on
VBoxManage modifyvm $VM --boot1 dvd --boot2 disk --boot3 none --boot4 none
VBoxManage modifyvm $VM --memory 1024 --vram 128
VBoxManage modifyvm $VM --nic1 bridged --bridgeadapter1 enp34s0
VBoxHeadless -s $VM


