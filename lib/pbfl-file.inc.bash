#!/bin/bash
################################################################################
# Pegasus' Linux Administration Tools	#		Pegasus' Bash Function Library #
# (C)2017-2018 Mattijs Snepvangers		#				 pegasus.ict@gmail.com #
# License: MIT							#	Please keep my name in the credits #
################################################################################

################################################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools"
# SCRIPT_TITLE="File(system) Operations Script"
# MAINTAINER="Mattijs Snepvangers"
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"
# VER_MAJOR=0
# VER_MINOR=0
# VER_PATCH=14
# VER_STATE="ALPHA"
# BUILD=20180803
# LICENSE="MIT"
################################################################################

### File(System) operations ####################################################
add_line_to_file() { ### Inserts line into file if it's not there yet
	_LINE_TO_ADD=$1
	_TARGET=$2
	_line_exists() {
		grep -qsFx "$LINE_TO_ADD" "$TARGET_FILE"
	}
	dbg_line "LINE_TO_ADD: $_LINE_TO_ADD"
	dbg_line "TARGET: $_TARGET"
	if [ $(_line_exists) ]
	then
		info_line "line already exists, leaving it undisturbed"
	else
		if [ -w "$_TARGET" ]
		then
			printf "%s\n" "$_LINE_TO_ADD" >> "$_TARGET"
			info_line "$_TARGET has been updated"
		else
			crit_line "CRITICAL: $_TARGET not writeable: Line could not be added"
		fi
	fi
}

edit_line_in_file() {
	local _SEARCH_FOR="$1"
	local _REPLACE_WITH="$2"
	local _FILE="$3"
	#dbg_line "Replacing $_SEARCH_FOR with $_REPLACE_WITH in $_FILE"
	local _QUERY="sed -i 's/"
	_QUERY+="$_SEARCH_FOR"
	_QUERY+=".*/"
	_QUERY+="$_REPLACE_WITH"
	_QUERY+="/' "
	_QUERY+="'$_FILE'"
	#echo $_QUERY
	local _RESULT=("$_QUERY")
	#if [ $_RESULT!=0 ]
	#then
	#	err_line "edit_line_in_file(): Something went wrong"
	#fi
}

add_to_script() { #adds line or blob to script
	local _TARGET="$1"
	local _LINE_OR_BLOB="$2"
	local _MESSAGE="$3"
	if [ "${LINE_OR_BLOB}" == "line" ] || [ ${LINE_OR_BLOB} == true ]
	then
		echo "$MESSAGE" >> "$TARGET"
	elif [ "$LINE_OR_BLOB" == blob ]
	then
		cat "$MESSAGE" >> "$TARGET"
	else
		err_line "unknown value: $_LINE_OR_BLOB"
		exit 1
	fi
}

create_dir() { ### Creates directory if it doesn't exist
	local _DIR	;	_DIR="$1"
	# UMASK=$2, OWNER=$3, GROUP=$4
	if [ ! -d "$_DIR" ]
	then
		mkdir -p "$_DIR"
	fi
#	if [ "x$2" != "x" ]
	#then
		#chmod $2 "$_DIR"
	#fi
	#if [ "x$3" != "x" ]
	#then
		#if [ "x$4" != "x" ]
		#then
			#chown $3:$4 "$_DIR"
		#else
			#chown $3 "$_DIR"
		#fi
	#fi
}

create_file() { ### Creates file if it doesn't exist
	set +u
	local _FILE		;	_FILE="$1"
	local _UMASK	;	_UMASK="$2"
	local _OWNER	;	_OWNER="$3"
	local _GROUP	;	_GROUP="$4"
	if [ ! -f "$_FILE" ]
	then
		dbg_line "$_FILE doesn't exist, creating."
		touch "$_FILE"
	else
		dbg_line "$_FILE already exists, leaving it alone."
	fi
	if [ "x$_UMASK" != "x" ]
	then
		chmod "$_UMASK" "$_FILE"
	fi
	if [ "x$_OWNER" != "x" ]
	then
		if [ "x$_GROUP" != "x" ]
		then
			chown "$_OWNER:$_GROUP" "$_FILE"
		else
			chown "$_OWNER" "$_FILE"
		fi
	fi
}

create_logfile() {
    create_file $LOG_FILE
    declare -gr LOG_FILE_CREATED=true
}

file_exists() { ### Checks if file exists
				# usage: file_exists $FILE
	$_FILE=$1
	if [ -f "$_FILE" ]
	then
		echo true
	else
		echo false
	fi
}

# fun: go_home
# txt: determins where the script is called from and if this is the same
#      location the script resides. If not, moves to that directory.
# use: go_home
# api: internal
go_home() {
	info_line "go_home: Where are we being called from?"
	declare -g CURRENT_DIR	;	CURRENT_DIR=$(pwd)
	if [[ $SCRIPT_DIR != $CURRENT_DIR ]]
	then
		info_line "go_home: We're being called outside our basedir, \
		going home to \"$SCRIPT_DIR\"..."
		cd "$SCRIPT_DIR"
	else
		info_line "go_home: We're right at home. :-) "
	fi
}

purge_dir() {
	local _DIR	;	_DIR="$1"
	rm -rf "$_DIR/*" && rm -rf "$_DIR/.*"
}
