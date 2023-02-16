#!/bin/bash

# Define the default FILENAME variable
FILENAME='servers'

# Describe scripts usage with simple function
usage(){
 echo "Usage: ${0} [-nsv] [-f FILE] COMMAND." >&2
 echo "Executes COMMAND as a single command on every server." >&2
 echo "  -f FILE  Use FILE for the list of servers. Default: /vagrant/servers." >&2
 echo "  -s       Execute the COMMAND using sudo on the remote server." >&2
 echo "  -n       Dry run mode. Display the COMMAND that would have been executed and exit" >&2
 echo "  -v       Verbose mode. Displays the server name before executing COMMAND." >&2
 exit 1
}


# Enforce user to run this script without superuser priviliges. If root priviliges required prompt user to -s command instead
if [[ "${UID}" -eq 0 ]]
then
  echo "Do not use sudo to execute this script. Use the -s option instead" >&2
  usage
fi

# Parse command line options with getopts
while getopts nsvf: OPTION
do
  case ${OPTION} in
  s) SUPERUSER='true' ;;
  n) DRY_RUN='true' ;;
  v) VERBOSITY='true' ;;
  f) FILENAME="${OPTARG}" ;;
  ?) usage ;;
  esac
done

# Remove the options while leaving the other arguments
shift $((OPTIND - 1))

  
# If the user does not supply any arguments give them help
if [[ "${#}" -lt 1 ]]
then
  echo "You must supply at least 1 command to execute: " >&2
  usage
fi


# Anything remaining in the command line must be treated as a single command
BASE_COMMAND="ssh -o ConnectTimeout=2"


# If the -s flag is given execute commands with sudo/root priviliges
if [[ "${SUPERUSER}" = 'true' ]]
then
  COMMANDS="sudo ${@}"
else
  COMMANDS="${@}"
fi

# Make sure that the SERVER_LIST FILE exists
if [[ ! -e "${FILENAME}" ]]
then
  echo "${FILENAME} does not exists or could not be read". >&2
  exit 1
fi

for SERVERNAME in $(cat ${FILENAME})
do
  # For verbose mode display the server's name before executing the commands
  if [[ "${VERBOSITY}" = 'true' ]]
  then
    echo "${SERVERNAME}:"
  fi
  # For dry run mode only echo the executed command to the standart output.
  if [[ "${DRY_RUN}" = 'true' ]]
  then
    echo "DRY RUN: ${BASE_COMMAND} ${SERVERNAME} ${COMMANDS}" 
  else
    ${BASE_COMMAND} ${SERVERNAME} ${COMMANDS}
    
    if [[ "${?}" -ne 0 ]]
    then
      EXIT_STATUS="${?}"
      echo "Execution on ${SERVERNAME} failed." >&2
    fi      
fi
done  
exit "${EXIT_STATUS}"
