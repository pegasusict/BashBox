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
# VER_PATCH=10
# VER_STATE="ALPHA"
# BUILD=20180710
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
	echo $_QUERY
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
	if [ "$LINE_OR_BLOB" == line ] || [ "$LINE_OR_BLOB" == true ]
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
	_DIR="$1"
	# UMASK=$2, OWNER=$3, GROUP=$4
	if [ ! -d "$_DIR" ]
	then
		mkdir "$_DIR"
	fi
	if [ "x$2" != "x" ]
	then
		chmod $2 "$_DIR"
	fi
	if [ "x$3" != "x" ]
	then
		if [ "x$4" != "x" ]
		then
			chown $3:$4 "$_DIR"
		else
			chown $3 "$_DIR"
		fi
	fi
}

#create_file() { ### Creates file if it doesn't exist
	#local _FILE=$1
	##UMASK=$2
	##OWNER=$3
	##GROUP=$4
	#if [ ! -f "$_FILE" ]
	#then
		#touch "$_FILE"
	#fi
	#if [ "x$2" != "x" ]
	#then
		#chmod $2 "$_FILE"
	#fi
	#if [ "x$3" != "x" ]
	#then
		#if [ "x$4" != "x" ]
		#then
			#chown $3:$4 "$_FILE"
		#else
			#chown $3 "$_FILE"
		#fi
	#fi
#}

create_logfile() {
    create_file $LOG_FILE
    declare -gr LOG_FILE_CREATED=true
}

create_file() { ### Creates file if it doesn't exist
	local _FILE="$1"
	if [ ! -f "$_FILE" ]
	then
		dbg_line "$_FILE doesn't exist, creating."
		touch "$_FILE"
	else
		dbg_line "$_FILE already exists, leaving it alone."
	fi
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

go_home() { # If we're not in the base directory of the script,
					##+ let's go there to prevent stuff from going haywire
	#dbg_line "Let's find out where we're at..."
	#EXEC_PATH="${BASH_SOURCE[0]}"
	#while [ -h "$EXEC_PATH" ]
	#do # resolve $EXEC_PATH until the file is no longer a symlink
		#local TARGET="$(readlink "$EXEC_PATH")"
		#if [[ $TARGET == /* ]]
		#then
			#dbg_line "EXEC_PATH '$EXEC_PATH' is an absolute symlink to '$TARGET'"
			#EXEC_PATH="$TARGET"
		#else
			#DIR="$(dirname "$EXEC_PATH")"
			#dbg_line "EXEC_PATH '$EXEC_PATH' is a relative symlink to '$TARGET' (relative to '$DIR')"
			#EXEC_PATH="$DIR/$TARGET"
		#fi
	#done
	#dbg_line "EXEC_PATH is $EXEC_PATH"
	#THIS_SCRIPT="$(basename $EXEC_PATH)"
	#BASE_DIR=$(dirname "$EXEC_PATH")
	#RDIR="$( dirname "$EXEC_PATH" )"
	#DIR="$( cd -P "$( dirname "$EXEC_PATH" )" && pwd )"
	#if [ "$DIR" != "$RDIR" ]
	#then
		#dbg_line "DIR '$RDIR' resolves to '$DIR'"
	#fi
	#dbg_line "DIR is '$DIR'"
	#THIS_SCRIPT=$(basename $EXEC_PATH)
	#BASE_DIR=$(dirname "$EXEC_PATH")
	#if [[ $(pwd) != "$BASE_DIR" ]]
	#then
		#cd "$BASE_DIR"
	#fi
	#dbg_line "Now we're in the base directory\"$BASE_DIR\""
##--------------------------------------------------------------------------------------
	info_line "go_home: Where are we being called from?"
	declare -gr SCRIPT_FULL="${COMMAND##*/}"
	declare -gr SCRIPT="${SCRIPT_FULL%.*}"
	declare -gr SCRIPT_PATH="$(readlink -fn $COMMAND)"
	declare -gr SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
	declare -g CURRENT_DIR=$(pwd)
	if [[ $SCRIPT_DIR != $CURRENT_DIR ]]
	then
		info_line "go_home: We're being called outside our basedir, going home to \"$SCRIPT_DIR\"..."
		cd "$SCRIPT_DIR"
	else
		info_line "go_home: We're right at home. :-) "
	fi
}

purge_dir() {
	local _DIR="$1"
	rm -rf "$_DIR" && mkdir "$_DIR"
	create_dir "$_DIR"
}
