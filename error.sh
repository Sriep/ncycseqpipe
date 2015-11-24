#!/bin/bash -e
#

PROGNAME=$(basename $0)
function error_exit ()
{
    #echo "${PROGNAME}: ${1:-"Unknown Error"}" 1>&2
    #exit 1
    
  local parent_lineno="$1"
  local message="$2"
  local code="${3:-1}"
  if [[ -n "$message" ]] ; then
    echo "${PROGNAME}: Error on or near line ${parent_lineno}: ${message}; exiting with status ${code}"
  else
    echo "${PROGNAME}: Error on or near line ${parent_lineno}; exiting with status ${code}"
  fi
  exit "${code}"
}

#use like this
#error ${LINENO} "the foobar failed" 2
