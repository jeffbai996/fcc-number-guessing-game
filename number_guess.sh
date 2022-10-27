#!/bin/bash

# add psql variable
PSQL="psql -X --username=freecodecamp --dbname=game --tuples-only -c"

MAIN_MENU() {
  # get username
  echo "Enter your username: "
  read USERNAME

  # find user
  FOUND_USER=$($PSQL "SELECT * FROM users WHERE username = '$USERNAME'")

  # if found
  if [[ $FOUND_USER ]]
  then
    echo $FOUND_USER | while IFS=" |" read USER_ID USERNAME GAMES_PLAYED BEST_GAME
    do
      echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
    done
  else
    # if not found
    echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
    INSERT_USER_RESULT=$($PSQL "INSERT INTO users(username) VALUES ('$USERNAME')")
  fi

  GAME
}

GAME() {
  # generate random number
  RAND_NUM=$(( $RANDOM % 1000 + 1))
  # count guesses
  TRIES=0
  # get guess
  echo -e "\nGuess the secret number between 1 and 1000: "
  # remove later
  echo -e "\nHint: it's $RAND_NUM"
  read GUESS

until [[ $GUESS -eq $RAND_NUM ]]
do
  while ! [[ $GUESS =~ ^[0-9]+$ ]]
  do
    echo -e "\nThat is not an integer, guess again:"
    read GUESS
  done

  if [[ $GUESS -lt $RAND_NUM ]]
  then
    echo -e "\nIt's higher than that, guess again: "
    read GUESS
    let TRIES++
  elif [[ $GUESS -gt $RAND_NUM ]]
  then
    echo -e "\nIt's lower than that, guess again: "
    read GUESS
    let TRIES++
  fi
done

echo -e "\nYou guessed it in $TRIES tries. The secret number was $RAND_NUM. Nice job!"
}

MAIN_MENU
