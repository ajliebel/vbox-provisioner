until  nc -zv "$1" 22
do
   echo "Waiting for ssh"
   sleep 5
done
sleep 5
echo "you can now connect to $1"
