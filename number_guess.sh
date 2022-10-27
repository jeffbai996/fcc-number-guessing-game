#!/bin/bash

# add psql variable
PSQL="psql -X --username=freecodecamp --dbname=game --tuples-only -c"

# generate random number
RAND_NUM=$(( $RANDOM % 1000 ))

# get username
echo "Enter your username: "
read USERNAME

# find user
USER=$($PSQL "SELECT * FROM users WHERE username = $USERNAME::TEXT")

# if not found
if [[ -z $USER ]]
then
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
fi