#!/bin/bash
# Script para backup de kong-postgres 

# Parametros
# 1 - curl para traer el serve donde corre y el slaveID
#lo comento porque es local en mi maquina
###curle=$(curl   http://localhost:18082/v2/apps/infrastructure/kong-pgsql/tasks)

#curle para hacer desde qa
curle=$(curl marathon.mesos:8080/v2/apps/infrastructure/kong-pgsql/tasks)
# obtener el host
echo $curle | jq '.tasks[0].host'

#obtener el slaveID
echo $curle | jq '.tasks[0].slaveId'



# 2 - logueamos a la maquina donde corre

# 3 - docker ps y nos traemos la que responda al slaveID ese

# 4 - Ahora si el backup
# 5 - seguimos con el tema de las keys


##IMPORTANTE
##DESA >> CORRI COMO PSEUDO-ROOT - SUDO BASH... ver que onda en cada ambiente
docker exec -t $KONGPGSLQ pg_dumpall -c -U postgres > /data/kong/postgresql/dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql




