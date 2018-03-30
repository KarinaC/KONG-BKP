#!/bin/bash
# Print slaveId and host

HOSTIP   = curl -s localhost:8080/v2/apps/infrastructure/kong-pgsql/tasks | awk -F'"' '{print $14}'
SLAVEID  = curl -s localhost:8080/v2/apps/infrastructure/kong-pgsql/tasks | awk -F'"' '{print $10}'

ssh-copy-id $HOSTIP

ssh -t -o LogLevel=QUIET $HOSTIP uptime
