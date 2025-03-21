#!/bin/bash

## Print out processes running for the current user

user=$(echo $USER)
echo "Running as $user. Processes for this user:"
ps -u $user
