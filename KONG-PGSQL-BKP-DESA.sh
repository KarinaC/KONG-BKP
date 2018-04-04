#!/bin/bash

############################################
# Search where Postgres run, and the SlaveId
############################################

SLAVEID="mesos-"

HOSTIP=$( curl -s localhost:8080/v2/apps/infrastructure/kong-pgsql/tasks | awk -F'"' '{print $14}' )
SLAVEID+=$( curl -s localhost:8080/v2/apps/infrastructure/kong-pgsql/tasks | awk -F'"' '{print $10}' )

###########################################
# Copy the sshid to avoid password request
##########################################

ssh-copy-id $HOSTIP

############################
# Getting the container NAME
############################

CONTAINER=$( ssh -t -o LogLevel=QUIET $HOSTIP sudo docker ps | grep lapp-dvde004:5000/postgres | awk -F' {2,}' 'END {print $1}' )

###################
# Doing the BACKUP
###################

ssh -t -o LogLevel=QUIET $HOSTIP "echo 'The container ID is' $CONTAINER; sudo docker exec -t $CONTAINER pg_dumpall -c -U postgres > /data/kong/postgresql/dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql"

#############################
# Doing the BACKUP 2ndVERSION
#############################

ssh -t -o LogLevel=QUIET $HOSTIP "echo 'The container ID is' $CONTAINER; sudo docker run -it --rm --name "KONG-PGSQL-BKP" -v /opt/pgsql-bkp:/dump-bkp lapp-dvde004:5000/postgres:9.4 pd_dumpall -h hostname -c -U postgres gzip -9 > /dump-bkp/dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql"

