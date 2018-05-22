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
# VERSION_PATCH=18									  #
# VERSION_STATE="PRE-ALPHA"							  #
# VERSION_BUILD=20180517							  #
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
	local _OPTIONS=${3:-false} # eg: ("j", "ja", "y", "yes", "n", "nee", "no")
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

### Headers & Lines ############################################################
header() {	### generates a header
			# usage: header $CHAR $LEN
			# $CHAR defaults to # and $LEN defaults to 80
	local _CHAR=${1:-#}
	local _LEN=${2:-80}
	local _HEADER=$(make_line "$_CHAR" "$_LEN")
	_HEADER+=$(header_line "$PROGRAM_SUITE" "$SCRIPT_TITLE" "$_CHAR" "$_LEN")
	_HEADER+=$(header_line "$COPYRIGHT" "$MAINTAINER_EMAIL" "$_CHAR" "$_LEN")
	_HEADER+=$(header_line "$SHORT_VERSION" "Build $VERSION_BUILD" "$_CHAR" "$_LEN")
	_HEADER+=$(header_line "License: $LICENSE" "Please keep my name in the credits" "$_CHAR" "$_LEN")
	_HEADER+="\n$(make_line $_CHAR $_LEN)"
	printf "%s\n" $_HEADER
}

header_line() {	### generates a header-line
				# usage: header_line $PART1 $PART2 $CHAR $LEN $SPACER
				# $CHAR defaults to "#", $LEN to 80 and spacer to " "
	local _PART1="$1"
	local _PART2="$2"
	local _CHAR=${3:-#}
	local _LEN=${4:-}
	local _SPACER=${5:-" "}
	local _SPACERS=$_SPACER
	local _HEADER_LINE="# $_PART1$_SPACERS$_PART2 #"
	for (( i=${#_HEADER_LINE}; i<MAX_WIDTH; i++ ))
		do _SPACERS+=$_SPACER
	done
	local _NEW_HEADER_LINE="# $_PART1$_SPACERS$_PART2 #"
	printf "%s\n" "$_NEW_HEADER_LINE"
}

make_line() { ### generates a line
			  # usage: make_line [$CHAR [$LEN [$LINE]]]
			  # $CHAR defaults to "#" and $LEN defaults to 80
	_CHAR=${1:-#}
	_LEN=${2:-80}
	_LINE=${3:-#}
	for (( i=${#_LINE}; i<_LEN; i++ ))
		do _LINE+=$CHAR
	done
	printf "%s\n" "$_LINE"
}

### LOGGING ####################################################################
set_verbosity() { ### Set verbosity level
	dbg_line "setting verbosity to $1"
	case $1 in
		1	)	declare -gr VERBOSITY=1; info_line "Verbosity is set to CRITICAL"	;	shift	;;	### Be vewy, vewy quiet... Will only show Critical errors which result in an untimely exiting of the script
		2	)	declare -gr VERBOSITY=2; info_line "Verbosity is set to ERROR"		;	shift	;;	# Will show errors that don't endanger the basic functioning of the program
		3	)	declare -gr VERBOSITY=3; info_line "Verbosity is set to WARNING"	;	shift	;;	# Will show warnings
		4	)	declare -gr VERBOSITY=4; info_line "Verbosity is set to INFO"		;	shift	;;	# Let me know what youre doing, every step of the way
		5	)	declare -gr VERBOSITY=5; info_line "Verbosity is set to DEBUG"		;	shift	;;	# I want it all, your thoughts and dreams too!!!
		*	)	declare -gr VERBOSITY=4; info_line "Verbosity is default: INFO"		;	shift	;	break	;;	## DEFAULT
	esac
}

###
crit_line() { ### CRITICAL MESSAGES
	local _MESSAGE="$1"
	logline 1 "$_MESSAGE"
}
err_line() { ### ERROR MESSAGES
	local _MESSAGE="$1"
	log_line 2 "$_MESSAGE"
}
warn_line() { ### WARNING MESSAGES
	local _MESSAGE="$1"
	log_line 3 "$_MESSAGE"
}
info_line() { ### VERBOSE MESSAGES
	local _MESSAGE="$1"
	log_line 4 "$_MESSAGE"
}
dbg_line() { ### DEBUG MESSAGES
	if [[ $VERBOSITY -ge 5 ]]
	then
		local _MESSAGE="$1"
		log_line 5 "$_MESSAGE"
	fi
}
###
log_line() {	# creates a nice logline and decides what to print on screen and
				#+ what to send to logfile based on VERBOSITY and IMPORTANCE levels
				# messages up to level 4 are sent to log
				# if verbosity = 5, all messages are printed on screen and sent to log incl debug
				# usage: log_line <importance> <message>
	_log_line_length() {
		local _LINE=""
		_LINE="$_LOG_HEADER$_MESSAGE"
		echo ${#_LINE}
	}
	local _IMPORTANCE=$1
	local _LABEL=""
	local _LOG_HEADER=""
	local _MESSAGE="$2"
	local _LOG_LINE_FILLER=""
	local _SCREEN_LINE_FILLER=""
	local _SCREEN_LINE=""
	local _SCREEN_OUTPUT=""
	local _LOG_OUTPUT=""
	case $_IMPORTANCE in
		1	)	_LABEL="CRITICAL:"	;;
		2	)	_LABEL="ERROR:   "	;;
		3	)	_LABEL="WARNING: "	;;
		4	)	_LABEL="INFO:    "	;;
		5	)	_LABEL="DEBUG:   "	;;
	esac
	_LOG_HEADER="$(get_timestamp) # $_LABEL"
	### generating screen output
	if (( "$_IMPORTANCE" <= "$VERBOSITY" ))
	then
		local IMAX=$SCREEN_WIDTH-$(_log_line_length)
		for (( i=2 ; i<IMAX ; i++ ))
		do
			_SCREEN_LINE_FILLER+="#"
		done
		_SCREEN_LINE="$_MESSAGE $_SCREEN_LINE_FILLER"
		case $_IMPORTANCE in
			1	)	_SCREEN_OUTPUT=$(crit_colours "$_LOG_HEADER" "$_SCREEN_LINE")	;;
			2	)	_SCREEN_OUTPUT=$(err_colours "$_LOG_HEADER" "$_SCREEN_LINE")		;;
			3	)	_SCREEN_OUTPUT=$(warn_colours "$_LOG_HEADER" "$_SCREEN_LINE")	;;
			4	)	_SCREEN_OUTPUT=$(info_colours "$_LOG_HEADER" "$_SCREEN_LINE")	;;
			5	)	_SCREEN_OUTPUT=$(dbg_colours "$_LOG_HEADER" "$_SCREEN_LINE")		;;
		esac
		echo -e "$_SCREEN_OUTPUT"
	fi
	### generating log output
	local IMAX=$LOG_WIDTH-$(_log_line_length)
	for (( i=1 ; i<IMAX ; i++ ))
	do
		_LOG_LINE_FILLER+="#"
	done
	_LOG_OUTPUT="$_LOG_HEADER $_MESSAGE $_LOG_LINE_FILLER"
	tolog "$_LOG_OUTPUT"
}

tolog() {
	local _LOG_ENTRY="$1"
	if [ $LOG_FILE_CREATED != true ]
	then
		if [ -z ${LOG_BUFFER+x} ] ; then declare -g LOG_BUFFER="" ; fi
		LOG_BUFFER+="\n$_LOG_ENTRY"
	else
		if [ -n "$LOG_BUFFER" ]
		then
			echo -e "$_LOG_BUFFER" >> "$LOG_FILE"
			unset $_LOG_BUFFER
			echo "$_LOG_ENTRY" >> "$LOG_FILE"
		else
			echo "$_LOG_ENTRY" >> "$LOG_FILE"
		fi
	fi
}
