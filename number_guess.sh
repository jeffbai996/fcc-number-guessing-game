#!/bin/bash

# add psql variable
PSQL="psql -X --username=freecodecamp --dbname=game --tuples-only -c"

MAIN_MENU() {
  # get username
  echo "Enter your username:"
  read USERNAME

  # find user
  FOUND_USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME'")

  # if found
  if [[ -z $FOUND_USER_ID ]]
  then
    echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
    INSERT_USER=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  else
    GAMES_PLAYED=$($PSQL "SELECT MIN(games_played) FROM users WHERE user_id = '$FOUND_USER_ID'")
    BEST_GAME=$($PSQL "SELECT MIN(best_game) FROM users WHERE user_id = '$FOUND_USER_ID'")
    echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
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

INCREMENT_GAMES_PLAYED=$($PSQL "UPDATE users SET games_played=$(($GAMES_PLAYED+1)) WHERE username='$USERNAME'")
UPDATE_BEST_GAME=$($PSQL "UPDATE users SET best_game=$TRIES WHERE username='$USERNAME' AND (best_game>$TRIES OR best_game = 0)")

echo -e "\nYou guessed it in $TRIES tries. The secret number was $RAND_NUM. Nice job!"
}

MAIN_MENU