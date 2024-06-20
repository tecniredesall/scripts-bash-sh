#!/bin/bash
cd /Users/freddy.hidalgo/Codes/GRAINCHAIN_PRODUCTS/TRANSFORMACIONES/transformaciones-api
release=release/stg/v1.15-v2

git reset --hard && git checkout $release

i=$(($#-1))
while [ $i -ge 0 ];
do
    sleep 5
    branch=${BASH_ARGV[$i]}
    echo $branch &&
    git checkout $branch && git checkout $release && git merge -X theirs $branch 
    i=$((i-1))
    
done
 
