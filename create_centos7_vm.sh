VM="$1"
mkdir /mnt/disk-1/shared/vbox/$VM
VBoxManage createhd --filename /mnt/disk-1/shared/vbox/$VM/$VM.vdi --size 32768
VBoxManage createvm --name $VM --ostype "Redhat_64" --register
VBoxManage storagectl $VM --name "SATA Controller" --add sata --controller IntelAHCI
VBoxManage storageattach $VM --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium /mnt/disk-1/shared/vbox/$VM/$VM.vdi
VBoxManage storagectl $VM --name "IDE Controller" --add ide
#VBoxManage storageattach $VM --storagectl "IDE Controller" --port 0 
VBoxManage storageattach $VM --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium /mnt/disk-1/shared/software/CentOS-7-x86_64-Minimal-2003.iso
VBoxManage modifyvm $VM --ioapic on
VBoxManage modifyvm $VM --boot1 dvd --boot2 disk --boot3 none --boot4 none
VBoxManage modifyvm $VM --memory 1024 --vram 128
VBoxManage modifyvm $VM --nic1 hostonly --hostonlyadapter1 vboxnet0 --cableconnected1 on
VBoxManage modifyvm $VM --nic2 bridged --bridgeadapter2 enp34s0 --cableconnected2 on
VBoxManage unattended install $VM  --iso=/mnt/disk-1/shared/software/CentOS-7-x86_64-Minimal-2003.iso --user=adrian --full-user-name=Adrian --password=foobar.123 --script-template=centos7_ks.cfg 
#//--start-vm=headless

MAC=`VBoxManage showvminfo $VM  --machinereadable | grep macaddress1 | sed 's/"//g' | sed -r 's/^.{12}//' | sed 's!\(..\)!\1:!g'|  sed 's!:$!!' | sed 's/./\L&/g'`
echo $MAC
until sudo arp-scan --interface=vboxnet0 --localnet | grep $MAC
do 
   echo "Waiting for IP"
   sleep 1
done 
sudo arp-scan --interface=vboxnet0 --localnet | grep $MAC
