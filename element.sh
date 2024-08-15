#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

INPUT=$1
MAIN_PROGRAM() {
  if [[ -z $INPUT ]]
  then
  echo Please provide an element as an argument.
  else
  PRINT_ELEMENT 
  fi
}

PRINT_ELEMENT() {
  if [[ ! $INPUT =~ ^[0-9]+$ ]]
  then
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$INPUT' OR symbol = '$INPUT'")
  else
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $INPUT")
  fi
  if [[ -z $ATOMIC_NUMBER ]]
  then
  echo I could not find that element in the database.
  
  else
  NAME=$(echo $($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER") | sed "s/ //g")
  SYMBOL=$(echo $($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER") | sed "s/ //g")
  TYPE=$(echo $($PSQL "SELECT type FROM elements WHERE atomic_number = $ATOMIC_NUMBER") | sed "s/ //g")
  MASS=$(echo $($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER") | sed "s/ //g")
  MELT=$(echo $($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER") | sed "s/ //g")
  BOIL=$(echo $($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER") | sed "s/ //g")
  
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  fi
  }

MAIN_PROGRAM

