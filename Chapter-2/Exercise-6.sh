#!/bin/bash

# 
if command -v node &>/dev/null;
then
	:
else
	echo "Installing nodeJS."
	sudo apt -y install nodejs
fi
node_version=$(node -v)
echo "NodeJS version ${node_version:1} installed."

if command -v npm &>/dev/null;
then
	:
else
	echo "Installing NPM."
	sudo apt -y install npm
fi
npm_version=$(npm -v)
echo "NPM version $npm_version installed."

echo "Downloading the Node App"
mkdir -p node-App
wget https://node-envvars-artifact.s3.eu-west-2.amazonaws.com/bootcamp-node-envvars-project-1.0.0.tgz
tar -xvzf bootcamp-node-envvars-project-1.0.0.tgz -C node-App/
echo "Node App downloaded and unpacked, deleting archive."
rm *.tgz*

export APP_ENV="dev"
export DB_USER="myuser"
export DB_PWD="mysecret"

cd node-App/package
npm install >/dev/null
node server.js &>/dev/null &
echo "server.js is running in the background. Exiting this script."
