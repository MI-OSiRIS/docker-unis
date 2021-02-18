#!/bin/bash

HOSTNAME=`hostname`
UNIS_PORT=8888

[ ! -z "$PORT" ] && UNIS_PORT=$PORT

sudo service mongodb start
sudo /etc/init.d/redis-server start

echo "UNIS IP : `hostname --ip-address`"
periscoped --port ${UNIS_PORT} -d DEBUG -c /etc/periscope/unis.cfg -S
