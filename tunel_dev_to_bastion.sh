#!/bin/bash



configServer=''
passBastion=''
timeOut=0
userServer=''
passServer=''


ipServerDev=0
ipServerBastion=0

portApi=0
portWeb=0
portWorker=0
portSsh=0
portBd=0

portServer=0

scriptCooperativa=''
reset=0
services=''
ipServerDev=192.168.100.131
ipServerBastion=192.168.100.26


reset_OverBastionFromCoperativas()
{
    echo "INIT PROCESS - RESET TO ORIGIN"
    echo $scriptCooperativa
    sshpass -p $passBastion scp  "$scriptCooperativa"  bastion@$ipServerBastion:/home/bastion/ &&
    sleep 1 &&
    nohup sshpass -p $passBastion ssh bastion@$ipServerBastion 'bash -s' < tunel_bastion_to_cooperativa.sh "configServer=$configServer" "portServer=$portServer" "timeOut=$timeOut" "userServer=$userServer" "passServer=$passServer" "portApi=$portApi" "portWeb=$portWeb" "portWorker=$portWorker" "portBd=$portBd" "portSsh=$portSsh" "reset=$reset" &
    sleep 4
    echo "END PROCESS - RESET TO ORIGIN"
}


createTunelOverBastionFromCoperativas()
{
    echo "INIT PROCESS - OPEN REVERSE PORT FROM COOPERATIVA"
    echo $scriptCooperativa
    sshpass -p $passBastion scp  "$scriptCooperativa"  bastion@$ipServerBastion:/home/bastion/ &&
    sleep 1 &&
    nohup sshpass -p $passBastion ssh bastion@$ipServerBastion 'bash -s' < tunel_bastion_to_cooperativa.sh "configServer=$configServer" "portServer=$portServer" "timeOut=$timeOut" "userServer=$userServer" "passServer=$passServer" "portApi=$portApi" "portWeb=$portWeb" "portWorker=$portWorker" "portBd=$portBd" "portSsh=$portSsh" "reset=$reset" &
    sleep 5


    maxRetry=30
    contador=0

    while [ "$maxRetry" -gt "$contador" ]
    do
        sleep 2
        echo "isMakedTunelOverBastion: $isMakedTunelOverBastion "
        echo "retry number: $contador "
        status=$(sshpass -p $passBastion ssh bastion@$ipServerBastion tail "logs_on_$configServer.txt")
        echo $status | sed -e 's/[[:blank:]]/\n/g' | grep 'make_tunel=true' > ./logs_tunel_cooperativa.txt
        st=$(cat ./logs_tunel_cooperativa.txt | grep make_tunel=true)
        if [ -z "$st" ]
        then
            echo 1
            contador=$(( contador+1 ))
             
        else 
            echo 2
            contador=$(( contador+30 ))
        fi
    done
    echo "FINISH PROCESS - OPEN REVERSE PORT FROM CUADRITZAL"
}

makeTunelOverDevFromBastion()
{
    echo "OPEN REVERSE PORT FROM BASTION"
    nohup sshpass -p $passBastion ssh -f -L  "$ipServerDev:$portApi:127.0.0.1:$portApi" -p 22 bastion@$ipServerBastion sleep $timeOut &
    nohup sshpass -p $passBastion ssh -f -L "$ipServerDev:$portWeb:127.0.0.1:$portWeb" -p 22 bastion@$ipServerBastion sleep $timeOut &
    nohup sshpass -p $passBastion ssh -f -L "$ipServerDev:$portWorker:127.0.0.1:$portWorker" -p 22 bastion@$ipServerBastion sleep $timeOut &
    nohup sshpass -p $passBastion ssh -f -L "$ipServerDev:$portSsh:127.0.0.1:$portSsh" -p 22 bastion@$ipServerBastion sleep $timeOut &
    nohup sshpass -p $passBastion ssh -f -L "$ipServerDev:$portBd:127.0.0.1:$portBd" -p 22 bastion@$ipServerBastion sleep $timeOut &
    echo "FINISH PROCESS - OPEN REVERSE PORT FROM BASTION"
}
 

killTunel()
{
    kill -9 `lsof -i -P -n | grep LISTEN | grep :$1 |  awk '//{print  $2 }' | tail -n 1`
}

checkForwarding()
{
    infoPort=$(lsof -i -P -n | grep LISTEN | grep :$1)
    echo "port=$infoPort" >> ./LogPortForwarding.txt
}

configServers()
{
    case "$1" in
        "solcafe") 
            env_solcafe
            ;;
        "proexo") 
            env_proexo
            ;;
        "capucas") 
            env_capucas
            ;;
        "sanmarcos") 
            echo $configServer
            env_sanmarcos
            ;;
         *) echo "ERROR"
    esac  
}

env_sanmarcos()
{
    ipServerDev=192.168.100.131
    ipServerBastion=192.168.100.26
    scriptCooperativa="./sanmarcos.sh"

    portServer=43032
    portApi=9031
    portWeb=9032
    portWorker=9033
    portSsh=6030
    portBd=6031

    #portMongo
    #portSocket
    #portRabbitMq
}

env_capucas()
{
    ipServerDev=192.168.100.131
    ipServerBastion=192.168.100.26
    scriptCooperativa="./capucas.sh"

    portServer=43022
    portApi=9021
    portWeb=9022
    portWorker=9023
    portSsh=6020
    portBd=6021

    #portMongo
    #portSocket
    #portRabbitMq
}


env_solcafe()
{
    ipServerDev=192.168.100.131
    ipServerBastion=192.168.100.26
    scriptCooperativa="./solcafe.sh"
    portServer=43026
    portApi=9011
    portWeb=9012
    portWorker=9013
    portSsh=6010
    portBd=6011

    #portMongo
    #portSocket
    #portRabbitMq
    
}

env_proexo()
{
    ipServerDev=192.168.100.131
    ipServerBastion=192.168.100.26
    scriptCooperativa="./proexo.sh"

    portServer=43035
    portApi=9001
    portWeb=9002
    portWorker=9003
    portSsh=6000
    portBd=6001

    #portMongo
    #portSocket
    #portRabbitMq
}


init(){

    configServers $configServer
    if [ -z "$passBastion" ] && [ -z "$timeOut" ]
    then
        echo 'MISSING PASSWORD OR timeOut'
    else


        killTunel $portApi
        killTunel $portWeb
        killTunel $portWorker
        killTunel $portSsh
        killTunel $portBd
        
        if [ $reset -eq 1 ]
        then
            reset_OverBastionFromCoperativas
            sleep 5
            reset_OverBastionFromCoperativas
            sleep 5
            reset_OverBastionFromCoperativas
        else
            createTunelOverBastionFromCoperativas
            echo "CREATING TUNEL"
            sleep 5
            makeTunelOverDevFromBastion
            echo "TUNEL CREATED"   
        fi

        lsof -i -P -n | grep LISTEN
        sleep 10

        #nohup sshpass -p $passBastion ssh bastion@$ipServerBastion "rm -rf $scriptCooperativa" &
        exit 0
    fi
}


readParams(){
        
        
    #echo 'START AGAIN' > ./LogPortForwarding.txt
    if [ "$#" -eq 0 ]    
    then 
        echo 'FALTAN PARAMETROS DE ENTRADA'
        echo "configServer=$configServer"
        echo "passBastion=$passBastion"
        echo "timeOut=$timeOut"
        echo "userServer=$userServer"
        echo "passServer=$passServer"
        exit 0
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
            passBastion=*) 
                passBastion=$(echo "$i" | sed -e 's/passBastion=/''/g')
                ;;
            timeOut=*) 
                timeOut=$(echo "$i" | sed -e 's/timeOut=/''/g')
                ;;
            reset=*) 
                reset=$(echo "$i" | sed -e 's/reset=/''/g')
                ;;
            services=*) 
                services=$(echo "$i" | sed -e 's/services=/''/g')
                servs=$(echo $services | tr "," "\n")

                for service_port in $servs
                do
                    echo "$service_port"
                done
                ;;
        esac  
    done

    if [ $reset -eq 1 ]
    then
        echo 'reset'
        timeOut=60
    else
      if [ -z "$configServer"  ] || [ -z "$passBastion"  ] || [ "$timeOut" -eq 0 ] || [ -z "$userServer"  ] || [ -z "$passServer" ]  
        then
            echo 'FALTAN PARAMETROS DE ENTRADA'
            echo "configServer=$configServer"
            echo "passBastion=$passBastion"
            echo "timeOut=$timeOut"
            echo "userServer=$userServer"
            echo "passServer=$passServer"
        exit 1
        fi
        
    fi

  

}

readParams $@  && init

#abrir unos puertos especificos
#abrir otros puertos
