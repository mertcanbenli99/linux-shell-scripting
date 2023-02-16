#!/bin/bash

# Ensure that user that runs the script have root privileges


if [[ ${UID} -ne 0 ]]
then
  echo "You must have root priviliges to run this script"
  exit 1 
fi

# Get username from the standart input
read -p "Enter the username: " USER_NAME
# Get the real name (contents)
read -p "Enter the real name of the user for this account: " CONTENT
# Get the password
read -p "Enter the password: " PASSWORD

# Create the user with the password
useradd -c "${CONTENT}"	-m "${USER_NAME}"
# Check to see if useradd command succeeds.
if [[ "$?" -ne 0 ]]
then
  echo 'The account could not be created'
  exit 1
fi

# Set the password for the account
echo ${PASSWORD} | passwd --stdin ${USER_NAME}
if [[ $? -ne 0 ]]
then
  echo 'The password for the account could not be set.'
  exit 1
fi

# Force password change on first login
passwd -e ${USER_NAME}

# Display the new username password and host where the user was created
echo
echo "username: ${USER_NAME}"
echo
echo "password: ${PASSWORD}"
echo
echo "host name: ${HOSTNAME}"
exit 0
