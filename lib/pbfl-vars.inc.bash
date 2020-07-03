#!/bin/bash
################################################################################
# Pegasus' Linux Administration Tools  #      BashFrame #
# (C)2017-2018 Mattijs Snepvangers    #         pegasus.ict@gmail.com #
# License: MIT              #  Please keep my name in the credits #
################################################################################
# SCRIPT_TITLE="Variable Functions"
# VERSION=( 0 1 16 "DEV" 20200701 )
################################################################################

### VARS

# fun: create_var VAR_NAME VALUE
# txt: Creates an uppercase variable VAR_NAME with value VALUE
# use: create_var <var> VAR_NAME <var> VALUE
# api: vars
create_var() {
  _VAR="${1}"
  _VALUE="${2}"
  declare -gu ${_VAR}=${_VALUE}
}

dup_var() {
  local _STRING="$1"
  local _COUNT="$2"
  local _OUTPUT=$(printf "%-${_COUNT}s" "${_STRING}")
  echo "${_OUTPUT// /*}"
}

var_length() {
  echo ${#@}
}
### ARRAYS
#create_indexed_array() { ### sets $ARRAY to $VALUE1 --- $VALUEn
#             # usage create_indexed_array $ARRAY $VALUE1 [$VALUE2 ...]
#  _ARRAY=$1
#  declare -ga $_ARRAY=( "$[@]:1" )
#}

#create_assoc_array() { ### fills $ARRAY with $KEY=$VALUE pair(s)
# usage: create_assoc_array $ARRAY $KEY1 $VALUE1 [KEY2 $VALUE2 ...]
#  _ARRAY=$1
#  _ARGS=$@
#  for (( i=1 ; i<=_ARGS ; i+2 ))
#  do
#    declare -gA $_ARRAY=( [${_ARGS[$i]}]=${_ARGS[$i+1]} )
#  done
#}

key_exists() {
    local _KEY="$1"
    local _ARRAY="$2"
    if test "${_ARRAY[${_KEY}]+isset}"
    then
        echo true
    else
        echo false
fi
}

value_exists() {
  local n=$#
  local value=${!n}
  for ((i=1;i < $#;i++)) {
    [[ "${!i}" == "${value}" ]] && echo true
  }
  echo false
}

###STRING MANIPULATION
str_to_lower() {
  echo "${1,,}"
}

str_to_upper() {
  echo "${1^^}"
}
