#!/bin/bash


## This application checks whether Java is installed, which version of Java is installed, and installs a newer version if it is below version 11

# Check what OS is used. 
# Currently only Ubuntu and Arch are supported.
source /etc/os-release
distribution_id=$(echo "$ID")
echo "This system is running $distribution_id."

if [ "$distribution_id" = "ubuntu" ];
then 
    packagemanager="apt"
    update="sudo apt update"
    inst="sudo apt -y install default-jre"
elif [ "$distribution_id" = "arch" ];
then 
    packagemanager="pacman"
    update="sudo pacman -Sy"
    inst="sudo pacman -S jre-openjdk-headless --noconfirm"
else
    echo "Distribution not supported. Exiting"
    exit 1
fi

echo "Checking if Java is installed."
if command -v java &>/dev/null; 
then 
    echo "Java is installed."
else
    echo "Java is not installed. Installing now!"
    echo "Please enter your password when prompted!"
    $update
    $inst 
    echo "Checking installation."
    if command -v java &>/dev/null;
    then
	echo "Java successfully installed!"
    else
	echo "Java was not installed correctly. Please try again! Exiting."
	exit 1
    fi
fi

echo "Checking Java version."
java_version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
major_java_version=${java_version%%.*}
if [ $major_java_version -ge 11 ];
then  
     echo "Currently the version $java_version is installed and satisfies the condition of Java version 11 or higher is installed. Success!"
else
     echo "Java version $java_version is installed and doesn't satisfy our goal to have Java version 11 or higher installed. Exiting with an error!"
     exit 1
fi

