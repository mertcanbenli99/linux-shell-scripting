#!/bin/bash

# This script demonstrates I/O redirection.

# Redirect STDOUT to a file.
FILE="/tmp/data"
head -n1 /etc/passwd > ${FILE}

# Redirect STDIN to a program
read LINE < ${FILE}
echo "LINE contains: ${LINE}"

# Redirect STDOUT to a file, overwriting the file
head -n3 /etc/passwd > ${FILE}
echo "contents of file: ${FILE}"
cat ${FILE}

# Redirect STDOUT to a file, appending to the file
echo "${RANDOM} ${RANDOM}" >> ${FILE}
echo "${RANDOM} ${RANDOM}" >> ${FILE}
echo
echo "contents of ${FILE}:"
cat ${FILE}

# Redirect STDIN to a program, using FD0.
read LINE 0< ${FILE}
echo
echo "LINE containts: ${LINE}"

# Redirect STDOUT to a file using FD1, overwriting the file
head -n3 /etc/passwd 1> ${FILE}
echo
echo "Contents of ${FILE}:"
cat ${FILE}


# Redirect STDERR to a file using FD 2.
ERR_FILE="/tmp/data.err"
head -n3 /etc/passwd /fakefile 2> ${ERR_FILE}


# Redirect STDOUT and STDERR to a file.
head -n2 /etc/passwd /etc/hosts /fakefile &> ${FILE}
echo
echo "Contents of ${FILE}:"
cat ${FILE}

# Redirect STDOUT and STDERR through a pipe.
echo
head -n3 /etc/passwd /fakefile |& cat -n

# Send output tı STDERR
echo  "This is STDERR" >&2

# Discard STDOUT4
echo "discarding STDOUT:"
head -n3 /etc/passwd /fakefile > /dev/null

# Discard sTDERR
echo
echo "Discarding STDERR:"
head -n3 /etc/passwd /fakefile 2> /dev/null

# Discard both STDOUT AND STDERR
echo
echo "Discarding STDOUT and STDERR:"
head -n3 /etc/passwd /fakefile &> /dev/null

# Clean up
rm ${FILE} ${ERR_FILE} &> /dev/null
