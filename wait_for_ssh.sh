until  nc -zv "$1" 22
do
   echo "Waiting for ssh"
   sleep 1
done
echo "you can now connect to $1"
