#!/bin/bash
################################################################################
# Pegasus' Linux Administration Tools	#		Pegasus' Bash Function Library #
# (C)2017-2018 Mattijs Snepvangers		#				 pegasus.ict@gmail.com #
# License: MIT							#	Please keep my name in the credits #
################################################################################

################################################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools"
# SCRIPT_TITLE="Variable Functions Library Script"
# MAINTAINER="Mattijs Snepvangers"
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"
# VER_MAJOR=0
# VER_MINOR=1
# VER_PATCH=15
# VER_STATE="PRE-ALPHA"
# BUILD=20180710
# LICENSE="MIT"
################################################################################

### VARS
create_var() {	### sets $VAR to $VALUE
				# varname is automatically changed to uppercase
	_VAR=$1
	_VALUE=$2
	declare -gu $_VAR=$_VALUE
}

dup_var() {
	local _STRING=$1
	local _COUNT=$2
	local _OUTPUT=$(printf "%-${COUNT}s" "$STRING")
	echo "${_OUTPUT// /*}"
}

### ARRAYS
#create_indexed_array() { ### sets $ARRAY to $VALUE1 --- $VALUEn
#						 # usage create_indexed_array $ARRAY $VALUE1 [$VALUE2 ...]
#	_ARRAY=$1
#	declare -ga $_ARRAY=( "$[@]:1" )
#}

#create_associative_array() { ### fills $ARRAY with $KEY=$VALUE pair(s)
#							 # usage create_associative_array $ARRAY $KEY1 $VALUE1 [KEY2 $VALUE2 ...]
#	_ARRAY=$1
#	_ARGS=$@
#	for (( i=1 ; i<=_ARGS ; i+2 ))
#	do
#		declare -gA $_ARRAY=( [${_ARGS[$i]}]=${_ARGS[$i+1]} )
#	done
#}

#key_exists() {
#	local _KEY="$1"
#	local _ARRAY="$2"
#	if [] # key exists in array
#	then
#		echo true
#	else
#		echo false
#	fi
#}

value_exists() {
    local n=$#
    local value=${!n}
    for ((i=1;i < $#;i++)) {
        if [ "${!i}" == "${value}" ]; then
            echo "y"
            return 0
        fi
    }
    echo "n"
    return 1
}
#value_exists() {
#	local _VALUE="$1"
#	local _ARRAY="$2"
#	if [] # value exists in array
#	then
#		echo true
#	else
#		echo false
#	fi
#}

###STRING MANIPULATION
str_to_lower() {
	echo "${1,,}"
}

str_to_upper() {
	echo "${1^^}"
}
