#!/bin/bash

# This script generates a random password.
# This user can set the password lenght with -l and add a special characcter with -s option
# Verbose mode can be enabled with -v.


usage() {
  echo "Usage: ${0} [-vs] [-l LENGTH]" >&2
  echo 'Generate a random password.'
  echo ' -l LENGTH Specify the password length.'
  echo ' -s Append a special character to the password.'
  echo ' -v Increase verbosity'
  exit 1
}

verbosity() {
  local MESSAGE="${@}"
  if [[ "${VERBOSE}" = 'true' ]]
  then
    echo "${MESSAGE}"
  fi
}




# Set a default password length
LENGTH=48

while getopts vl:s OPTION
do
  case ${OPTION} in
   v) VERBOSE='true'; verbosity 'Verbose mode on.' ;;
   l) LENGTH="${OPTARG}";;
   s) USE_SPECIAL_CHARACTER='true' ;;
   ?) usage ;;
  esac
done



# Remove the options while leaving the remaining arguments.
shift "$(( OPTIND - 1 ))"



if [[ "${#}" -gt 0 ]]
then
  usage
fi


verbosity 'Generating a password'

# Generate a password
PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c${LENGTH})

# Append a special charecter if requested to do so.
if [[ "${USE_SPECIAL_CHARACTER}" = 'true' ]]
then
  verbosity 'Selecting a random special character.'
  SPECIAL_CHARACTER=$(echo '"!^+%&/()=?_~;:*/+-' | fold -w1 | shuf | head -c1)
  PASSWORD="${PASSWORD}${SPECIAL_CHARACTER}"
fi

verbosity 'Done.'
verbosity 'Here is the password:'

# Display the password
echo "${PASSWORD}"

exit 0

