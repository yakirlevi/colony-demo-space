#!/bin/bash
echo 'Installing mongodb 4.0'

echo 'Import the Public Key used by the Ubuntu Package Manager'
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6

echo 'Create a file list for mongoDB to fetch the current repository'
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.0.list

echo ' Update the Ubuntu Packages'
apt update 

echo 'Install MongoDB'
apt install mongodb-org -y

echo 'Change mongoDB Listening IP Address from local 127.0.0.1 to All IPs 0.0.0.0'
sed -i 's/127\.0\.0\.1/0\.0\.0\.0/g' /etc/mongod.conf

echo 'Start the mongo service'
service mongod start

echo 'Extracting user data db artifact'
mkdir $ARTIFACTS_PATH/drop
tar -xvf $ARTIFACTS_PATH/user-data-db.tar -C $ARTIFACTS_PATH/drop/

echo 'Importing users collection'
mongoimport --db promo-manager --collection users --file $ARTIFACTS_PATH/drop/users.json

echo 'Importing promotions collection'
mongoimport --db promo-manager --collection promotions --file $ARTIFACTS_PATH/drop/promotions.json

echo 'Enable automatically starting MongoDB when the system starts.'
sudo systemctl enable mongod