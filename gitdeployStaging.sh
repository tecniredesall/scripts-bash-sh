#!/bin/bash

pathWk=/Users/freddy.hidalgo/Codes/GRAINCHAIN_PRODUCTS/TRANSFORMACIONES/worker-sync
pathApi=/Users/freddy.hidalgo/Codes/GRAINCHAIN_PRODUCTS/TRANSFORMACIONES/transformaciones-api
pathWeb=/Users/freddy.hidalgo/Codes/GRAINCHAIN_PRODUCTS/TRANSFORMACIONES/transformaciones-web
pathEtl=/Users/freddy.hidalgo/Codes/GRAINCHAIN_PRODUCTS/TRANSFORMACIONES/etl-socio-notadepeso-suma-capucas
path="NOPATH"
branchFrom=$2
branchTo=$3
branchMaster=master
branchStaging=staging
branchDev=development

branchRelease=release/stg/$3
branchHotfix=hotfix/stg/$3
branchDeploy=$branchRelease
branchTo=$branchDeploy

useOrCreateBranch()
{
    branch=$1
    info=0
    errorGit="error: pathspec '"$branch"'"
    git checkout staging &&
    git checkout -b $branch || git checkout $branch
    git pull --set-upstream origin $branch 
    #git pull origin
}

branchForEnviroments()
{
    
    if [ -n "$1" ] &&  [  "$1" == "-wk" ]
    then
        branchDev=develop
    fi
    
    if [ -n "$1" ] &&  [  "$1" == "-api" ]
    then
        branchDev=development
    fi
    
    if [ -n "$1" ] &&  [  "$1" == "-web" ]
    then
        branchDev=development
    fi
    
    if [ -n "$1" ] &&  [  "$1" == "-etl" ]
    then
        branchDev=development
    fi
}

findBranch()
{
    rama=$branchFrom
    ev=$(git log | grep  $rama)
    if [ "$ev" ]
    then
        echo "->$ev"
        return 1
    else
        return 0
    fi
}

doMerge(){

    

    #git branch --merged  feature/SIL-7263 saber si una rama ya esta unida
    #git merge  shared/languages 
    noUpdate=$4
    path=$1
    cd  $path &&
    git reset --hard HEAD &&
    git checkout $branchMaster && git pull origin &&
    git checkout $branchStaging && git pull origin  &&
    git checkout $branchDev && git pull origin  &&
    ##develop=$(findBranch) &&
    git fetch &&
    git checkout $branchFrom  && git pull origin &&
    echo "MNO"$branchTo &&
    useOrCreateBranch $branchTo &&
    git checkout $branchTo &&
    git merge $branchFrom &&
    git push --set-upstream origin $branchTo &&
    echo "Merge Complete $develop"

    #hacer merge
}


if [ -n "$1" ] && [ -n "$2" ] && [ -n "$3" ]
then
    echo "Start merge in release branch"
else
    exit 0
fi

case "$1" in
    
    -wk)echo "-wk option passed"
    branchForEnviroments -wk
    doMerge $pathWk;;
    -api) echo "-api option passed"
    branchForEnviroments -api
    doMerge $pathApi;;
    -web) echo "-web option passed"
    branchForEnviroments -web
    doMerge $pathWeb;;
    -etl) echo "-etl option passed"
    branchForEnviroments -etl
    doMerge $pathEtl;;
    -all) echo "-all option passed"
    branchForEnviroments -wk && echo $branchDev
    doMerge $pathWk
    branchForEnviroments -api && echo $branchDev
    doMerge $pathApi
    branchForEnviroments -web && echo $branchDev
    doMerge $pathWeb
    branchForEnviroments -etl && echo $branchDev
    doMerge $pathEtl;;
    *) echo "No Path  - End Script"
    exit 1;;
esac
shift



#borrar una rama git server

#git push origin --delete fix/authentication
#git push origin :fix/authentication