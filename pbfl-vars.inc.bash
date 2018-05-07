#!/bin/bash -p
############################################################################
# Pegasus' Linux Administration Tools #		Pegasus' Bash Function Library #
# (C)2017-2018 Mattijs Snepvangers	  #				 pegasus.ict@gmail.com #
# License: MIT						  #	Please keep my name in the credits #
############################################################################

#######################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools" #
# SCRIPT_TITLE="Variable Functions Library Script"	  #
# MAINTAINER="Mattijs Snepvangers"					  #
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"			  #
# VERSION_MAJOR=0									  #
# VERSION_MINOR=1									  #
# VERSION_PATCH=0									  #
# VERSION_STATE="ALPHA"								  #
# VERSION_BUILD=20180504							  #
# LICENSE="MIT"										  #
#######################################################

create_var() {	### sets $VAR to $VALUE
				# varname is automatically changed to uppercase
	_VAR=$1
	_VALUE=$2
	declare -gu $_VAR=$_VALUE
}
create_indexed_array() { ### sets $ARRAY to $VALUE1 --- $VALUEn
						 # usage create_indexed_array $ARRAY $VALUE1 [$VALUE2 ...]
	_ARRAY=$1
	_ARGS=$@
	for (( i=1 ; i<=_ARGS ; i++ ))
	do
		declare -ga $_ARRAY$[$i]=( ${_ARGS[$i]} ) ###CHECK###
	done
}
create_associative_array() { ### fills $ARRAY with $KEY=$VALUE pair(s)
							 # usage create_associative_array $ARRAY $KEY1 $VALUE1 [KEY2 $VALUE2 ...]
	_ARRAY=$1
	_ARGS=$@
	for (( i=1 ; i<=_ARGS ; i+2 ))
	do
		declare -gA $_ARRAY$=( [${_ARGS[$i]}]=${_ARGS[$i+1]} )
	done
}
str_to_lower() {
	echo "${1,,}"
}
str_to_upper() {
	echo "${1^^}"
}
