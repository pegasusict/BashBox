#!/bin/bash
############################################################################
# Pegasus' Linux Administration Tools #		Pegasus' Bash Function Library #
# (C)2017-2018 Mattijs Snepvangers	  #				 pegasus.ict@gmail.com #
# License: MIT						  #	Please keep my name in the credits #
############################################################################

#######################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools" #
# SCRIPT_TITLE="Log Functions Script"				  #
# MAINTAINER="Mattijs Snepvangers"					  #
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"			  #
# VER_MAJOR=0									  #
# VER_MINOR=0									  #
# VER_PATCH=6									  #
# VER_STATE="PRE-ALPHA"							  #
# VER_BUILD=20180709							  #
# LICENSE="MIT"										  #
#######################################################

# mod: pbfl_logging
# txt: This script contains functions that facilitate logging messages to
#      logfile and screen

# fun: set_verbosity
# txt: declares global constant VERBOSITY, is usually called from get_args
# use: set_verbosity <INT> VERBOSITY
# api: logging
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

# fun: crit_line MESSAGE
# txt: Passes MESSAGE on to 'log_line 1'
# use: crit_line <var> MESSAGE
# api: logging
crit_line() {
	local _MESSAGE="$1"
	log_line 1 "$_MESSAGE"
}

# fun: err_line MESSAGE
# txt: Passes MESSAGE on to 'log_line 2'
# use: err_line <var> MESSAGE
# api: logging
err_line() {
	local _MESSAGE="$1"
	log_line 2 "$_MESSAGE"
}

# fun: warn_line MESSAGE
# txt: Passes MESSAGE on to 'log_line 3'
# use: warn_line <var> MESSAGE
# api: logging
warn_line() {
	local _MESSAGE="$1"
	log_line 3 "$_MESSAGE"
}

# fun: info_line MESSAGE
# txt: Passes MESSAGE on to 'log_line 4'
# use: info_line <var> MESSAGE
# api: logging
info_line() {
	local _MESSAGE="$1"
	log_line 4 "$_MESSAGE"
}

# fun: dbg_line MESSAGE
# txt: Passes MESSAGE on to 'log_line 5' if VERBOSITY is 5+
# use: dbg_line <var> MESSAGE
# api: logging
dbg_line() {
	if [[ $VERBOSITY -ge 5 ]]
	then
		local _MESSAGE="$1"
		log_line 5 "$_MESSAGE"
	fi
}

# fun: log_line IMPORTANCE MESSAGE
# txt: Creates a nice logline and decides what to print on screen and what to
#      send to logfile by comparing VERBOSITY and IMPORTANCE.
# use: log_line <INT> IMPORTANCE <VAR> MESSAGE
# api: logging_internal
log_line() {
	_log_line_length() {
		local _LINE="${_LOG_HEADER}${_MESSAGE}"
		echo ${#_LINE}
	}
	local _IMPORTANCE=$1
	local _LABEL=""
	local _LOG_HEADER=""
	local _MESSAGE="$2"
	local _CHAR="%"
	local _LOG_LINE_FILLER=""
	local _SCREEN_LINE_FILLER=""
	local _SCREEN_LINE=""
	local _SCREEN_OUTPUT=""
	local _LOG_OUTPUT=""
	local _LOG_LINE_FILLER_LENGTH=0
	local _SCREEN_LINE_FILLER_LENGTH=0
	if [ -z $SCREEN_WIDTH ]
	then
		get_screen_size
	fi
	case $_IMPORTANCE in
		1	)	_LABEL="CRITICAL:"	;;
		2	)	_LABEL="ERROR:   "	;;
		3	)	_LABEL="WARNING: "	;;
		4	)	_LABEL="INFO:    "	;;
		5	)	_LABEL="DEBUG:   "	;;
		*	)	_LABEL="INFO:    "	;;
	esac
	_LOG_HEADER="$(get_timestamp) % $_LABEL"
	### generating screen output
	if (( "$_IMPORTANCE" <= "$VERBOSITY" ))
	then
		_SCREEN_LINE_FILLER_LENGTH=$((SCREEN_WIDTH - $(_log_line_length)))
		_SCREEN_LINE_FILLER=$(dup_var "$_CHAR" $_SCREEN_LINE_FILLER_LENGTH)
		_SCREEN_LINE="$_MESSAGE $_SCREEN_LINE_FILLER"
		case $_IMPORTANCE in
			1	)	_SCREEN_OUTPUT=$(crit_colours "$_LOG_HEADER" "$_SCREEN_LINE")	;;
			2	)	_SCREEN_OUTPUT=$(err_colours "$_LOG_HEADER" "$_SCREEN_LINE")	;;
			3	)	_SCREEN_OUTPUT=$(warn_colours "$_LOG_HEADER" "$_SCREEN_LINE")	;;
			4	)	_SCREEN_OUTPUT=$(info_colours "$_LOG_HEADER" "$_SCREEN_LINE")	;;
			5	)	_SCREEN_OUTPUT=$(dbg_colours "$_LOG_HEADER" "$_SCREEN_LINE")	;;
		esac
		if (( IMPORTANCE >= 1 && IMPORTANCE <= 2 ))
		then
			echo -e "$_SCREEN_OUTPUT" >&2
		else
			echo -e "$_SCREEN_OUTPUT"
		fi
	fi
	### generating log output
	_LOG_LINE_FILLER_LENGTH=$((LOG_WIDTH - $(_log_line_length)))
	_LOG_LINE_FILLER=$(dup_var "$_CHAR" $_LOG_LINE_FILLER_LENGTH)
	_LOG_OUTPUT="$_LOG_HEADER $_MESSAGE $_LOG_LINE_FILLER"
	to_log "$_LOG_OUTPUT"
}

# fun: to_log
# txt: Checks whether the log file has been created yet and whether the log
#      buffer exists. The log entry will be added to the logfile if exist,
#      otherwise it will be added to the buffer which will be created if needed.
# use: to_log LOG_ENTRY
# api: logging_internal
to_log() {
	local _LOG_ENTRY	;	_LOG_ENTRY="$1"
	if [ "$LOG_FILE_CREATED" != true ]
	then
		if [ -z ${LOG_BUFFER+x} ]
		then
			declare -g LOG_BUFFER
			LOG_BUFFER="$START_TIME - $COMMAND Process started\n"
		fi
		LOG_BUFFER+="$_LOG_ENTRY"
	else
		to_log() {
			if [ -n "$LOG_BUFFER" ]
			then
				cat "$LOG_BUFFER" > "$LOG_FILE"
				unset $LOG_BUFFER
			else
				to_log() {
					echo "$_LOG_ENTRY" >> "$LOG_FILE"
				}
			fi
			echo "$_LOG_ENTRY" >> "$LOG_FILE"
		}
		to_log "$_LOG_ENTRY"
	fi
}
