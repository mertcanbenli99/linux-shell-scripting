#!/bin/bash

# Make sure the script is being executed with root priviliges
if [[ "${UID}" -ne 0 ]]
then
  echo "You must have root priviliges to execute this script".
  exit 1
fi

# If the user does not supply at least one argument give them help
if [[ "${#}" -eq 0 ]]
then
  echo "This script takes at least one parameter: [NAME]"
  exit 1
fi

# The first parameter is the user name
USER_NAME="${1}"

# Rest of the parameters are comment
shift
COMMENT="${@}"

#Generate a password.
SPECIAL_CHARACTER=$(echo '"!£^$%&/()=?_+-*\' | fold -w1 | shuf | head -c1)
PASSWORD="$(date +%s%N | sha256sum | head -c48)${SPECIAL_CHARACTER}"

# Create the user with the password
useradd -c "${COMMENT}" -m ${USER_NAME}

# Check to see useradd command succeeded
if [[ "${?}" -ne 0 ]]
then
  echo "Something went wrong"
  exit 1
else
  echo "User created successfully"
fi

# Set the generated password
echo "${PASSWORD}" | passwd --stdin $USER_NAME

# Check to see passwd command succeeded
if [[ "${?}" -ne 0 ]]
then
  echo "Something went wrong"
  exit 1
else
  echo "Password set successfully"
fi

# Force password change in next login
passwd -e $USER_NAME

# Display the username password and host where the user was created
echo "Username: ${USER_NAME}"
echo "Password: ${PASSWORD}"
echo "Host name: ${HOSTNAME}"

exit 0

