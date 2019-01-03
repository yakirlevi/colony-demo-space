#!/bin/bash
echo 'Installing mongodb 4.0'

echo 'Import the Public Key used by the Ubuntu Package Manager'
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4

echo 'Create a file list for mongoDB to fetch the current repository'
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list

echo ' Update the Ubuntu Packages'
apt-get update 

echo 'Install MongoDB'
apt-get install -y mongodb-org
# prevent auto updates
echo "mongodb-org hold" | sudo dpkg --set-selections
echo "mongodb-org-server hold" | sudo dpkg --set-selections
echo "mongodb-org-shell hold" | sudo dpkg --set-selections
echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
echo "mongodb-org-tools hold" | sudo dpkg --set-selections

echo 'Change mongoDB Listening IP Address from local 127.0.0.1 to All IPs 0.0.0.0'
sed -i 's/127\.0\.0\.1/0\.0\.0\.0/g' /etc/mongod.conf

echo 'Start the mongo service'
service mongod start

echo 'Enable automatically starting MongoDB when the system starts.'
sudo systemctl enable mongod

echo 'Extracting user data db artifact'
mkdir $ARTIFACTS_PATH/drop
tar -xvf $ARTIFACTS_PATH/user-data-db.tar -C $ARTIFACTS_PATH/drop/

echo 'Install mongo clients'
apt install mongodb-clients -y

echo 'Importing users collection'
mongoimport --db promo-manager --collection users --file $ARTIFACTS_PATH/drop/users.json

echo 'Importing promotions collection'
mongoimport --db promo-manager --collection promotions --file $ARTIFACTS_PATH/drop/promotions.json