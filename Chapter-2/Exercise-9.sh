#!/bin/bash

# 
serviceUser="myapp"
if id "$serviceUser" &>/dev/null; then
        echo "Running as user $serviceUser."
else
        echo "Creating user $serviceUser and running application as this user."
        sudo useradd $serviceUser -m
fi

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
# mkdir -p node-App
sudo runuser -l $serviceUser -c "wget https://node-envvars-artifact.s3.eu-west-2.amazonaws.com/bootcamp-node-envvars-project-1.0.0.tgz"
sudo runuser -l $serviceUser -c "tar -xvzf ./bootcamp-node-envvars-project-1.0.0.tgz"
echo "Node App downloaded and unpacked, deleting archive."
sudo runuser -l $serviceUser -c "rm *.tgz*"

log_dir=$1
if [ ! -d "$log_dir" ];
then
	echo "Log folder doesn't exist, creating."
	mkdir -p $log_dir
fi

#export LOG_DIR=$(realpath "$log_dir")
#export APP_ENV="dev"
#export DB_USER="myuser"
#export DB_PWD="mysecret"

#cd node-App/package
#working_dir=$(pwd)
#npm install >/dev/null

logDirPath=$(realpath "$log_dir")
echo $logDirPath

sudo chown $serviceUser -R $logDirPath

# npm install
sudo runuser -l $serviceUser -c "
	export APP_ENV=dev &&
	export DB_USER=myuser &&
	export DB_PWD=mysecret &&
	export LOG_DIR=$logDirPath &&
	cd package && 
	npm install &&
	node server.js &"


procInfo=$(sudo pgrep -l "node")
procName=$(echo $procInfo | awk '{print $2}')
pid=$(echo $procInfo | awk '{print $1}')
sleep 1
listenPort=$(sudo ss -tulnp | awk '/node/ {split($5, a, ":"); print a[length(a)]}')

echo "server.js is running in the background with the process name $procName and PID $pid, listening on port $listenPort."

if [ "$2" = "kill" ]; then
	sudo kill $pid
fi


