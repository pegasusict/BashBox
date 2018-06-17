#!/bin/bash
############################################################################
# Pegasus' Linux Administration Tools #		Pegasus' Bash Function Library #
# (C)2017-2018 Mattijs Snepvangers	  #				 pegasus.ict@gmail.com #
# License: MIT						  #	Please keep my name in the credits #
############################################################################

#######################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools" #
# SCRIPT_TITLE="User Interaction Functions Script"	  #
# MAINTAINER="Mattijs Snepvangers"					  #
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"			  #
# VERSION_MAJOR=0									  #
# VERSION_MINOR=1									  #
# VERSION_PATCH=22									  #
# VERSION_STATE="PRE-ALPHA"							  #
# VERSION_BUILD=20180617							  #
# LICENSE="MIT"										  #
#######################################################

### Basic program ##############################################################
version() { ### returns version information
	echo -e "\n$PROGRAM $VERSION - $COPYRIGHT $MAINTAINER"
}

### User Interaction ###########################################################
ask() {	### Asks the user a question and returns the answer
		# usage: ask $QUESTION [$OPTIONS]
		# If OPTIONS is provided, will only accept any of these as answer
	local _QUESTION="$1"
	local _OPTIONS=${1:-false} # eg: ("j", "ja", "y", "yes", "n", "nee", "no")
	local _ANSWER=""
	local _FINAL_ANSWER=""
	###
	echo -e "\n$_QUESTION\n"
	read _ANSWER
	if [ $_OPTIONS != false ]
	then
		for _OPTION in $_OPTIONS
		do
			if [ "${_OPTION,,}" == "${_ANSWER,,}" ]
			then
				_FINAL_ANSWER=$ANSWER
			fi
		done
		if [ $_FINAL_ANSWER == "" ]
		then
			err_message "No valid answer received from user"
			exit 2
		fi
	else
		_FINAL_ANSWER=$_ANSWER
	fi
	echo -e _FINAL_ANSWER
}

prompt() {	### prompt a user for information
			# usage: prompt $QUESTION $PASS [$OPTIONS]
			# If OPTIONS is provided, will only accept any of these as answer
			# if $PASS is true, OPTIONS will be ignored
	local _QUERY="$1"
	local _PASS=${2:-false}
	local _OPTIONS=$3 # eg: ("j", "ja", "y", "yes", "n", "nee", "no")
	local _ANSWER
	local _FINAL_ANSWER=""
	###
	if [ "$_PASS" == false ]
	then
		read -p $_ANSWER
	else
		read -sp $_ANSWER
	fi
	if [ $_OPTIONS != false ]
	then
		for _OPTION in $_OPTIONS
		do
			if [ "${_OPTION,,}" == "${_ANSWER,,}" ]
			then
				_FINAL_ANSWER=$ANSWER
			fi
		done
		if [ $_FINAL_ANSWER == "" ]
		then
			err_message "No valid answer received from user"
			exit 2
		fi
	else
		_FINAL_ANSWER=$_ANSWER
	fi
	echo -e _FINAL_ANSWER
}

choose() {
	local _QUESTION="$1"
	echo "$_QUESTION"
	select yn in "Yes" "No"; do
		case $yn in
			Yes	)	local _CHOICE="true"	;	break;;
			No	)	local _CHOICE="false"	;	break;;
		esac
	done
	echo "$_CHOICE"
}
