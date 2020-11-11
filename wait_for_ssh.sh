until  nc -zv 192.168.56.114 22
do
   echo "Waiting for ssh"
   sleep 1
done
echo "you can now ssh root@192.168.56.114"
