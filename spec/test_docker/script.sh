trap "{ echo 'got int'; exit 0; }" SIGINT SIGTERM
while : 
do
 echo "running" 
 sleep 1
done
