#!/bin/bash
echo 'Run mongodb service'
# Start the MongoDB Service
service mongod start

# block while mongod is running
while true
do  
  sleep 1
done
