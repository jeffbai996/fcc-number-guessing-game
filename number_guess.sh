#!/bin/bash

# add psql variable
PSQL="psql -X --username=freecodecamp --dbname=games --tuples-only -c"

# generate random number
RAND_NUM=$(( $RANDOM % 1000 ))

echo "Enter your username: "
read USERNAME

