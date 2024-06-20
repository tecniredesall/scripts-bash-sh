#!/bin/bash
pass=$2
options=$1
time=$3
ipServer=10.10.100.3
ipServerDev=192.168.100.131

apiPort=8080
apiPortTest=9031
workerPort=8000
workerPortTest=9033

fileLog=/var/www/logs.txt


replaceIpToOriginal()
{
    set +H &&
    cd /var/www/dist
    sshpass -p $pass  sudo sed  -i "s/$ipServerDev/$ipServer/g" $(find main*)
    sshpass -p $pass  sudo sed  -i "s/$ipServer:$apiPortTest/$ipServer:$apiPort/g" $(find main*)
    sshpass -p $pass  sudo sed  -i "s/$ipServer:$workerPortTest/$ipServer:$workerPort/g" $(find main*)
    set -H 
}

replaceIpToTest()
{
    set +H &&
    cd /var/www &&
    echo "start replace ip from $ipServer to $ipServerDev " >> $fileLog
    cd /var/www/dist &&
    sshpass -p "$pass"  sudo sed  -i "s/$ipServer/$ipServerDev/g" $(find main*) 
    sshpass -p "$pass"  sudo sed  -i "s/$ipServerDev:$apiPort/$ipServerDev:$apiPortTest/g" $(find main*)
    sshpass -p "$pass"  sudo sed  -i "s/$ipServerDev:$workerPort/$ipServerDev:$workerPortTest/g" $(find main*) 
    cd /var/www &&

    echo "finish replace ip from $ipServer to $ipServerDev " >> $fileLog &&

    set -H 



}



init(){
    cd /var/www &&
    set +H
    case "$options" in
        "test") 
            echo "SERVER TEST" >> $fileLog
            replaceIpToTest
            ;;
        "reset") 
            echo "SERVE" >> $fileLog
            replaceIpToOriginal
            ;;
         *) echo "lala"
    esac  
    set -H
}



set +H &&
cd /var/www &&

sshpass -p "$pass" sudo touch $fileLog &&
sshpass -p "$pass" sudo chown www-data:www-data $fileLog &&
sshpass -p "$pass" sudo chmod 666 $fileLog &&
echo "START SCRIPT" > $fileLog &&
set -H &&
init
