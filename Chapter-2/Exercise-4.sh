#!/bin/bash

## Print out processes running for the current user and sort them by memory or CPU usage.

user=$(echo $USER)
echo "Running as $user. Display processes for this user sorted by:"
echo "[1] CPU usage (descending) or [2] memory usage (descending)."

while true;
    do
	read choice

	if [ "$choice" = 1 ]; 
	then 
		echo "Processes for $user sorted by CPU usage (descending):"
		ps -u $user --sort=-%cpu
		break
	elif [ "$choice" = 2 ];
	then
		echo "Processes for $user sorted by memory usage (descending):"
		ps -u $user --sort=-%mem
		break
	else
		echo "Please choose either 1 for sorting by CPU usage or 2 for sorting by memory usage"
	fi
done


