#!/bin/bash
echo 'Run mongodb service'
# Start the MongoDB Service
service mongod start

# block while mongod is running
while true
do
  RESULT=`ps -A | sed -n /mongod$/p`

  if [ "${RESULT:-null}" = null ]; then
    echo "not running"
    exit 1
  else
    echo "running"
  fi
  sleep 1
done
