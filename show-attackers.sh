#!/bin/bash

#Define the number of failed logins limit
LIMITT='10'


# Requires a file as command line argument to read
if [[ "${#}" -lt 1 ]]
then
  echo "Please provide a sample system log file" >&2
  exit 1
fi

# Make sure that the file exists and can be read.
if [[ ! -f "${1}" ]]
then
  echo "The file ${1} does not exits or could not be read" >&2
  exit 1
fi


# Display the CSV header.
echo 'Count,IP,Location'
grep 'Failed' syslog-sample | awk -F 'from ' '{print $2}' | cut -d ' ' -f 1 | sort | uniq -c | sort -nr | while read COUNT IP
do
  # if the number of failed attemps is greater than the limit display count
  if [[ "${COUNT}" -gt "${LIMIT}" ]]
  then 
    LOCATION=$(geoiplookup ${IP} | awk -F ', ' '{print $2}')
    echo "${COUNT},${IP},${LOCATION}"
  fi
done

exit 0

