#!/bin/bash

###################
# Variables setting 
###################


HOSTNAME=kong-pgsql.infrastructure.marathon.mesos
HOSTIP=$( nslookup -type=A kong-pgsql.infrastructure.marathon.mesos | grep 'Address: ' | awk -F':' '{print $2}' )
PORT=$(nslookup -type=SRV _kong-pgsql.infrastructure._tcp.marathon.mesos | grep service | awk -F' ' '{print $6}')
BKPPATH=/home/etcconit/KONG-PGSQL-BACKUPS
OBPATH=/home/etcconit/KONG-PGSQL-BACKUPS/OLDER-BACKUPS
KONGBKPLOG=/home/etcconit/KONG-PGSQL-BACKUPS/kong-bkp.log


##########################################################
# Move logs to  other folder and REMOVE olders than 7 days
##########################################################

echo " " > /home/etcconit/KONG-PGSQL-BACKUPS/kong-bkp.log
echo "Starting the kong backup script for `date +%d-%m-%Y"_"%H_%M_%S`" >> $KONGBKPLOG

#############################
# Check if path exists or not
#############################

if [ -d "$OBPATH" ]; then
    echo "The BKP path exists, continue to backup task" >> $KONGBKPLOG
else
    echo "The BKP path does not exists, it will be create and then move to the backup task" >> $KONGBKPLOG
    mkdir -p /home/etcconit/KONG-PGSQL-BACKUPS/OLDER-BACKUPS
fi


OLDBKP=$( find /home/etcconit/KONG-PGSQL-BACKUPS/dump_*.sql -type f -mtime -2 )
if [[ -n $OLDBKP ]]; 
then
    echo "There are old bkps to be moved to $OBPATH" >> $KONGBKPLOG
    mv $OLDBKP $OBPATH
    docker run -it --rm --name "KONG-PGSQL-BKP" lapp-dvde004:5000/postgres:9.4 pg_dumpall -h $HOSTNAME -p $PORT -c -U postgres > /home/etcconit/KONG-PGSQL-BACKUPS/dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql
else
    echo "There are not old bkps to be moved, proceeding with the BACKUP od the day" >> $KONGBKPLOG
    docker run -it --rm --name "KONG-PGSQL-BKP" lapp-dvde004:5000/postgres:9.4 pg_dumpall -h $HOSTNAME -p $PORT -c -U postgres > /home/etcconit/KONG-PGSQL-BACKUPS/dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql

fi

