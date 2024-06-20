#!/bin/bash

portServer=0
timeOut=0
userServer=''
passServer=''

portApi=0
portWeb=0
portWorker=0
portSsh=0
portBd=0

scriptCooperativa=''
reset=0


makeTunel()
{
    echo "START_MAKE_TUNEL=true" >> ./"logs_on_$configServer.txt"
    nohup ssh -f -L "$portApi:127.0.0.1:8080" -p $portServer $userServer@127.0.0.1 sleep $timeOut &    
    nohup ssh -f -L "$portWeb:127.0.0.1:80" -p $portServer $userServer@127.0.0.1 sleep $timeOut   &        
    nohup ssh -f -L "$portWorker:127.0.0.1:8000" -p $portServer $userServer@127.0.0.1 sleep $timeOut &        
    nohup ssh -f -L "$portSsh:127.0.0.1:22" -p $portServer $userServer@127.0.0.1 sleep $timeOut   &   
    nohup ssh -f -L "$portBd:127.0.0.1:3306" -p $portServer $userServer@127.0.0.1 sleep $timeOut  &
    echo "END_MAKE_TUNEL=true" >> ./"logs_on_$configServer.txt"
    sleep 5
    echo "make_tunel=true" >> ./"logs_on_$configServer.txt"
}


killTunel()
{
    kill -9 `lsof -i -P -n | grep LISTEN | grep :$1 |  awk '//{print  $2 }' | tail -n 1`
}

checkForwarding()
{
    infoPort=$(lsof -i -P -n | grep LISTEN | grep :$1)
    echo "$infoPort" >> ./LogPortForwarding.txt
    
}


init(){

    
   
    scriptCooperativa="./$configServer.sh"
    echo "" > ./"logs_on_$configServer.txt"
    echo $scriptCooperativa > ./"logs_on_$configServer.txt"
    

    echo "start_executed_script=true" >> ./"logs_on_$configServer.txt"
    killTunel $portApi
    killTunel $portWeb 
    killTunel $portWorker
    killTunel $portSsh
    killTunel $portBd
    if [ $reset -eq 1 ]
    then
        
        ssh -p $portServer "$userServer@127.0.0.1" 'bash -s' < "$scriptCooperativa" "reset" "$passServer" "$timeOut"
    else
        makeTunel 
        ssh -p $portServer "$userServer@127.0.0.1" 'bash -s' < "$scriptCooperativa" "test" "$passServer" "$timeOut"
        nohup $(sleep $timeOut && ssh -p $portServer "$userServer@127.0.0.1" 'bash -s' < "$scriptCooperativa" "reset" "$passServer" "$timeOut") &
        sleep 10
        checkForwarding $portApi
        checkForwarding $portWeb
        checkForwarding $portWorker
        checkForwarding $portSsh
        checkForwarding $portBd
    fi

    echo "end_executed_script=true" >> ./"logs_on_$configServer.txt"
}

printParams(){
        echo "portApi=$configServer" >> ./"logs_errors_on_$configServer.txt"
        echo "portApi=$portApi" >> ./"logs_errors_on_$configServer.txt" 
        echo "portWeb=$portWeb" >> ./"logs_errors_on_$configServer.txt"
        echo "portWorker=$portWorker" >> ./"logs_errors_on_$configServer.txt"
        echo "portBd=$portBd" >> ./"logs_errors_on_$configServer.txt"
        echo "portSsh=$portSsh" >> ./"logs_errors_on_$configServer.txt"

        echo "timeOut=$timeOut" >> ./"logs_errors_on_$configServer.txt"
        echo "userServer=$userServer" >> ./"logs_errors_on_$configServer.txt"
        echo "passServer=$passServer" >> ./"logs_errors_on_$configServer.txt"
        echo "portServer=$portServer" >> ./"logs_errors_on_$configServer.txt"
}




readParams(){
        
    echo 'START AGAIN1' > ./"logs_errors_on_$configServer.txt"
    echo 'START AGAIN1' > ./"logs_on_$configServer.txt"
    
    if [ "$#" -eq 0 ]    
    then 
        echo 'FALTAN PARAMETROS DE ENTRADA' >> ./"logs_errors_on_$configServer.txt"
        printParams
        exit 1
    fi 

    for i in "$@"
    do
        #echo "Argumento  $i"
        case "$i" in
            configServer=*) 
                configServer=$(echo "$i" | sed -e 's/configServer=/''/g')
                ;;
            userServer=*) 
                userServer=$(echo "$i" | sed -e 's/userServer=/''/g')
                ;;
            passServer=*) 
                passServer=$(echo "$i" | sed -e 's/passServer=/''/g')
                ;;
            timeOut=*) 
                timeOut=$(echo "$i" | sed -e 's/timeOut=/''/g')
                ;;
            portServer=*) 
                portServer=$(echo "$i" | sed -e 's/portServer=/''/g')
                ;;
            portApi=*) 
                portApi=$(echo "$i" | sed -e 's/portApi=/''/g')
                ;;
            portWeb=*) 
                portWeb=$(echo "$i" | sed -e 's/portWeb=/''/g')
                ;;
            portWorker=*) 
                portWorker=$(echo "$i" | sed -e 's/portWorker=/''/g')
                ;;
            portBd=*) 
                portBd=$(echo "$i" | sed -e 's/portBd=/''/g')
                ;;
            portSsh=*) 
                portSsh=$(echo "$i" | sed -e 's/portSsh=/''/g')
                ;;
            reset=*) 
                reset=$(echo "$i" | sed -e 's/reset=/''/g')
                ;;
        esac  
    done

    if [ $reset -eq 1 ]
    then
        echo 'tote' >> ./"plat.txt"
        timeOut=60
    else

        if [ -z "$configServer"  ] || [ "$timeOut" -eq 0 ] || [ "$timeOut" -eq 0 ] || [ -z "$userServer"  ] || [ -z "$passServer" ] || [ -z "$portServer" ] || [ "$portApi" -eq 0 ] || [ "$portWeb" -eq 0 ] || [ "$portWorker" -eq 0 ] || [ "$portBd" -eq 0 ] || [ "$portSsh" -eq 0 ]
        then
            echo 'FALTAN PARAMETROS DE ENTRADA' >> ./"logs_errors_on_$configServer.txt"
            printParams
            exit 1
        fi

    fi

}

readParams $@  && init


exit 0



