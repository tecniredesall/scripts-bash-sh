#!/bin/bash

FOLDER_NAME="git_auditor"
PATH_MAIN="/Users/freddy.hidalgo/Codes/GRAINCHAIN_PRODUCTS"
PATH_FT="$PATH_MAIN/TRANSFORMACIONES/transformaciones-web/"
PATH_API="$PATH_MAIN/TRANSFORMACIONES/transformaciones-api/"
PATH_WK="$PATH_MAIN/TRANSFORMACIONES/worker-sync/"
PATH_ETL="$PATH_MAIN/TRANSFORMACIONES/etl-socio-notadepeso-suma-capucas/"




# sh getBranchs.sh $PATH_FT $FOLDER_NAME
sh getBranchs.sh $PATH_API $FOLDER_NAME
# sh getBranchs.sh $PATH_WK $FOLDER_NAME
# sh getBranchs.sh $PATH_ETL $FOLDER_NAME

PATH_AUDITOR="$PATH_MAIN/TEST_NEWCODES/auditorBranch/functions/src/index.ts"
sleep 1

# ts-node $PATH_AUDITOR $PATH_FT $FOLDER_NAME master develop
ts-node $PATH_AUDITOR $PATH_API $FOLDER_NAME master develop
# ts-node $PATH_AUDITOR $PATH_WK $FOLDER_NAME master develop
# ts-node $PATH_AUDITOR $PATH_ETL $FOLDER_NAME master develop






