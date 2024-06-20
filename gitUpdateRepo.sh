#!/bin/bash

cd  /Users/freddy.hidalgo/Codes/GRAINCHAIN_PRODUCTS/TRANSFORMACIONES/transformaciones-web &&
git checkout -b bk_dev 2> /dev/null 
git checkout shared/languages && git pull  origin &&
git checkout master && git pull  origin &&
git checkout staging && git pull origin &&
git checkout development && git pull origin &&
git fetch &&
git branch -D bk_dev 2> /dev/null 
echo "End Update Repo Web" 

cd  /Users/freddy.hidalgo/Codes/GRAINCHAIN_PRODUCTS/TRANSFORMACIONES/worker-sync &&
git checkout -b bk_dev 2> /dev/null 
git checkout master && git pull origin  &&
git checkout staging && git pull origin &&
git checkout develop && git pull origin &&
git fetch &&
git branch -D bk_dev 2> /dev/null
echo "End Update Repo Worker Sync"

cd  /Users/freddy.hidalgo/Codes/GRAINCHAIN_PRODUCTS/TRANSFORMACIONES/transformaciones-api &&
git checkout -b bk_dev 2> /dev/null 
git checkout master && git pull  &&
git checkout staging && git pull  &&
git checkout development && git pull &&
git fetch &&
git branch -D bk_dev 2> /dev/null
echo "End Update Repo Api"

cd  /Users/freddy.hidalgo/Codes/GRAINCHAIN_PRODUCTS/TRANSFORMACIONES/etl-socio-notadepeso-suma-capucas &&
git checkout -b bk_dev 2> /dev/null 
git checkout master && git pull origin &&
git checkout staging && git pull origin &&
git checkout development && git pull origin &&
git fetch &&
git branch -D bk_dev 2> /dev/null
echo "End Update Repo ETL"









#agregar comimit
