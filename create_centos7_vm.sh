VM="$1"
mkdir /mnt/disk-1/shared/vbox/$VM
VBoxManage createhd --filename /mnt/disk-1/shared/vbox/$VM/$VM.vdi --size 32768
VBoxManage createvm --name $VM --ostype "Redhat_64" --register
VBoxManage storagectl $VM --name "SATA Controller" --add sata --controller IntelAHCI
VBoxManage storageattach $VM --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium /mnt/disk-1/shared/vbox/$VM/$VM.vdi
VBoxManage storagectl $VM --name "IDE Controller" --add ide

VBoxManage storageattach $VM --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium /mnt/disk-1/shared/software/CentOS-7-x86_64-Minimal-2003.iso
VBoxManage modifyvm $VM --ioapic on
VBoxManage modifyvm $VM --boot1 dvd --boot2 disk --boot3 none --boot4 none
VBoxManage modifyvm $VM --memory 1024 --vram 128
VBoxManage modifyvm $VM --nic1 nat --cableconnected1 on
VBoxManage modifyvm $VM --nic2 hostonly --hostonlyadapter2 vboxnet0 --cableconnected2 on
VBoxManage sharedfolder add $VM --name shared  --hostpath /mnt/disk-1/shared --automount --auto-mount-point /share1
VBoxManage unattended install $VM  --iso=/mnt/disk-1/shared/software/CentOS-7-x86_64-Minimal-2003.iso --user=adrian --full-user-name=Adrian --password=foobar.123 --script-template=centos7_ks.cfg  --start-vm=headless

MAC=`VBoxManage showvminfo $VM  --machinereadable | grep macaddress2 | sed 's/"//g' | sed -r 's/^.{12}//' | sed 's!\(..\)!\1:!g'|  sed 's!:$!!' | sed 's/./\L&/g'`
echo "Waiting for IP bound to MAC: " $MAC
until sudo arp-scan --interface=vboxnet0 --localnet | grep $MAC
do 
   sleep 10
done 
SCAN=`sudo arp-scan --interface=vboxnet0 --localnet | grep $MAC`
IP=`echo $SCAN | cut -c 1-15`
echo $IP
./wait_for_ssh.sh $IP

cat ~/.ssh/id_rsa.pub | sshpass -p "foobar.123" ssh -o StrictHostKeyChecking=no root@$IP "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"

ssh root@$IP yum update -y

ssh root@$IP yum install -y "kernel-devel-uname-r == $(uname -r)"

ssh root@$IP "yum install -y make gcc kernel-headers kernel-devel perl dkms bzip2 && reboot"

./wait_for_ssh.sh $IP

VBoxManage storageattach $VM --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium /mnt/disk-1/shared/software/VBoxGuestAdditions_6.1.2.iso

ssh root@$IP  mount -r /dev/cdrom /media
ssh root@$IP /media/VBoxLinuxAdditions.run

echo "DONE!!!"
