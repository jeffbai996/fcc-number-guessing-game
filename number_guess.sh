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
  INSERT_USER_RESULT=$($PSQL "INSERT INTO users(username) VALUES ('$USERNAME')")
else
  # if user found
  echo $USER | while IFS=" |" read USERNAME GAMES_PLAYED BEST_GAME
  do
    echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  done
fi

# get guess
echo -e "\nGuess the secret number between 1 and 1000: "
read GUESS

echo $GUESS