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
		sort="-%cpu"
		break
	elif [ "$choice" = 2 ];
	then
		sort="-%mem"
		break
	else
		echo "Please choose either 1 for sorting by CPU usage or 2 for sorting by memory usage"
	fi
done

echo "Please choose the number of processes to display:"

while true;
do 
	read proc_num

	if (( var == var ));
	then 
		break
	else
		echo "Please enter an integer!"
	fi
done

ps -u $user --sort=$sort | head -n $((proc_num+1))


