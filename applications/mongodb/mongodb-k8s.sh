#!/bin/bash
echo 'Running mongodb 4.0'

echo 'Change mongoDB Listening IP Address from local 127.0.0.1 to All IPs 0.0.0.0'
sed -i 's/127\.0\.0\.1/0\.0\.0\.0/g' /etc/mongod.conf

echo 'Start the mongo service'
service mongod start

echo 'Enable automatically starting MongoDB when the system starts.'
sudo systemctl enable mongod

echo 'Extracting user data db artifact'
mkdir $ARTIFACTS_PATH/drop
tar -xvf $ARTIFACTS_PATH/*.* -C $ARTIFACTS_PATH/drop/