#!/bin/bash
echo 'Installing mongodb 3.4'

# Import the Public Key used by the Ubuntu Package Manager
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6

# Create a file list for mongoDB to fetch the current repository
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list

# Update the Ubuntu Packages
apt update 

# Install MongoDB
apt install mongodb-org -y

# Change mongoDB Listening IP Address from local 127.0.0.1 to All IPs 0.0.0.0
sed -i 's/127\.0\.0\.1/0\.0\.0\.0/g' /etc/mongod.conf

# Enable automatically starting MongoDB when the system starts.
sudo systemctl enable mongod