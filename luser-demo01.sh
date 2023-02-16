#!/bin/bash

# This script displays various information to the screen

# Display 'Hello'
echo 'Hello'

# Assign a value to a variable
WORD='script'

# display the variable value.
echo $WORD

#  Demonstrate that sinlge quotes does not interpret variables
echo '$WORD'

# Double quotation marks interprets the variables

echo "This is a shell $WORD"
echo This is a shell $WORD

# Display the contents of the variable using an alternativ syntax

echo "This is a shell ${WORD}"

# Append text to the variable
echo "${WORD}ing is fun"
echo "$WORDing is fun" # this is not going to work

# Create a new variable
ENDING='ed'

# Combine the two variables.
echo "This is ${WORD}${ENDING}."

#Change the value stored in the ENDING variable (Reassignment.)
ENDING='ing'
echo "${WORD}${ENDING} is fun"
#Reassign value to ENDING.
ENDING='s'
echo "you are going to write many ${WORD}${ENDING} in this class."
