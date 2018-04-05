#!/bin/bash

###################
# Variables setting 
###################


HOSTNAME=kong-pgsql.infrastructure.marathon.mesos
HOSTIP=$( nslookup -type=A kong-pgsql.infrastructure.marathon.mesos | grep 'Address: ' | awk -F':' '{print $2}' )
PORT=$(nslookup -type=SRV _kong-pgsql.infrastructure._tcp.marathon.mesos | grep service | awk -F' ' '{print $6}')


##################
# Getting the BKP
##################

sudo docker run -it --rm --name "KONG-PGSQL-BKP" lapp-dvde004:5000/postgres:9.4 pg_dumpall -h $HOSTNAME -p $PORT -c -U postgres > /tmp/dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql
