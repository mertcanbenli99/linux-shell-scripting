#!/bin/bash

# Describe the path for the archive directory constatnt
readonly ARCHIVE_DIR='/archive'

# Check to see preceding command succeeded
check() {
  MESSAGE="${1}"
  if [[ "${?}" -ne 0 ]]
  then
    echo "${MESSAGE}"
    exit 1
  fi
}





# Describe script's usage method
usage() {
  echo "Usage: ${0} [-dra] [USER]" >&2
  echo 'disable the existing user by default.' >&2
  echo ' -d Deletes the user instead of disabling it.' >&2
  echo ' -r Removes the home directory associated with the account' >&2
  echo ' -a Creates an archive of the home directory associated with the account.' >&2
  exit 1

}

# This script must be executed with root priviliges
if [[ "${UID}" -ne 0 ]]
then
  echo "You must have root priviliges to execute this script" >&2
  exit 1
fi

# This script must take at least 1 argument (USERNAME) to delete
if [[ "${#}" -lt 1 ]]
then
  usage 
fi

# Parse command line options with getopts

while getopts dra OPTION
do
  case ${OPTION} in
  d) DELETE_USER='true' ;;
  r) REMOVE_OPTION='-r' ;;
  a) ARCHIVE_OPTIN='true';;
  ?) usage ;;
  esac
done

# Remove the options while leaving the other arguments
shift "$((OPTIND - 1))"

# Loop through the list of usernames given as command line arguments
for USERNAME in "${@}"
do
  echo "Processing user ${USERNAME}"
  # Make sure that user uid is not below 1000 to prevent users messing with the system accounts.
  if [[ "$(id -u ${USERNAME})" -lt 1000 ]]
  then
    echo "This account could not be removed" >&2
    exit 1
  fi
  # Create an archive if requested to do so
  if [[ "${ARCHIVE_OPTIN}" = 'true' ]]
  then
    # Make sure the ARCHIVE_DIR directory exists
    if [[ ! -d "${ARCHIVE_DIR}" ]]
    then
      echo "Creating ${ARCHIVE_DIR} directory".
      mkdir -p ${ARCHIVE_DIR}
      check "The archive directory ${ARCHIVE_DIR} could not be created."
    fi
  # Archive the user's home directory move it into the archive dir
  HOME_DIR="/home/${USERNAME}"
  ARCHIVE_FILE="${ARCHIVE_DIR}/${USERNAME}.tar.gz"
    if [[ -d "${HOME_DIR}" ]]
    then
      echo "Archiving ${HOME_DIR} to ${ARCHIVE_FILE}"
      tar -zcf ${ARCHIVE_FILE} ${HOME_DIR} &> /dev/null
      check "could not create ${ARCHIVE_FILE}"
    else
      echo "${HOME_DIR} does not exist or is not a directory." >&2
      exit 1
    fi
  fi

  if [[ "${DELETE_USER}" = 'true' ]]
  then
    # Delete/disable the user
    userdel ${REMOVE_OPTION} ${USERNAME}
  
    # Check to see userdel commands exit status
    check "The account ${USERNAME} could not be deleted."
  echo " The account ${USERNAME} was deleted."
 else
   chage -E 0 ${USERNAME}
   check "The account ${USERNAME} was NOT disabled."
   echo "The account ${USERNAME} was disabled."
  fi
done

exit 0
  



