#!/bin/bash
############################################################################
# Pegasus' Linux Administration Tools #		Pegasus' Bash Function Library #
# (C)2017-2018 Mattijs Snepvangers	  #				 pegasus.ict@gmail.com #
# License: GPL v3					  #	Please keep my name in the credits #
############################################################################

#######################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools" #
# SCRIPT_TITLE="Main Functions Library Script"		  #
# MAINTAINER="Mattijs Snepvangers"					  #
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"			  #
# VERSION_MAJOR=0									  #
# VERSION_MINOR=5									  #
# VERSION_PATCH=53									  #
# VERSION_STATE="ALPHA"								  #
# VERSION_BUILD=20180424							  #
#######################################################



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
			exit 1
		fi
	fi
}
add_to_script() { #adds line or blob to script
	local _TARGET_SCRIPT=$1
	local _LINE_OR_BLOB=$2
	local _MESSAGE=$3
	if [ "$LINE_OR_BLOB" == line ]
	then
		echo "$MESSAGE" >> "$TARGET_SCRIPT"
	elif [ "$LINE_OR_BLOB" == blob ]
	then
		cat "$MESSAGE" >> "$TARGET_SCRIPT"
	else
		err_line "unknown value: $_LINE_OR_BLOB"
		exit 1
	fi
}
create_dir() { ### Creates directory if it doesn't exist
	_TARGET_DIR=$1
	if [ ! -d "$_TARGET_DIR" ]
	then
		mkdir "$_TARGET_DIR"
	fi
}
create_file() { ### Creates file if it doesn't exist
	local _TARGET_FILE=$1
	local _UMASK=$2
	local _OWNER=$3
	local _GROUP=$4
	if [ ! -f "$_TARGET_FILE" ]
	then
		touch "$_TARGET_FILE"
	fi
	if [ var_is_set $_UMASK ]
	then
		chmod $_UMASK $_TARGET_FILE
	fi
	if [ var_is_set $_GROUP ]
	then
		chown 
}

######################################################################################################################
create_file_from_template() { ### render a template file
							  # expand variables + preserve formatting
							  #usage: create_file_from_template $TARGET_FILE $TEMPLATE
	local _TARGET_FILE=$1
	local _TEMPLATE=$2
	eval "echo \"$(cat $_TEMPLATE)\"" > $_TARGET_FILE
}
######################################################################################################################
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
goto_base_dir() { # If we're not in the base directory of the script,
				  #+ let's go there to prevent stuff from going haywire
	dbg_line "Let's find out where we're at..."
	EXEC_PATH="${BASH_SOURCE[0]}"
	while [ -h "$EXEC_PATH" ]
	do # resolve $EXEC_PATH until the file is no longer a symlink
		local TARGET="$(readlink "$EXEC_PATH")"
		if [[ $TARGET == /* ]]
		then
			dbg_line "EXEC_PATH '$EXEC_PATH' is an absolute symlink to '$TARGET'"
			EXEC_PATH="$TARGET"
		else
			DIR="$(dirname "$EXEC_PATH")"
			dbg_line "EXEC_PATH '$EXEC_PATH' is a relative symlink to '$TARGET' (relative to '$DIR')"
			EXEC_PATH="$DIR/$TARGET"
		fi
	done
	dbg_line "EXEC_PATH is $EXEC_PATH"
	THIS_SCRIPT="$(basename $EXEC_PATH)"
	BASE_DIR=$(dirname "$EXEC_PATH")
	RDIR="$( dirname "$EXEC_PATH" )"
	DIR="$( cd -P "$( dirname "$EXEC_PATH" )" && pwd )"
	if [ "$DIR" != "$RDIR" ]
	then
		dbg_line "DIR '$RDIR' resolves to '$DIR'"
	fi
	dbg_line "DIR is '$DIR'"
	THIS_SCRIPT=$(basename $EXEC_PATH)
	BASE_DIR=$(dirname "$EXEC_PATH")
	if [[ $(pwd) != "$BASE_DIR" ]]
	then
		cd "$BASE_DIR"
	fi
	dbg_line "Now we're in the base directory\"$BASE_DIR\""
}
purge_dir() {
	local _DIR="$1"
	rm -rf "$_DIR"
	create_dir "$_DIR"
}

### TMP OPS ###
create_tmp() { ### usage: create_tmp $PREFIX
	local _PREFIX=$1
	TMP_DIR=""
	TMP_FILE=""
	until [ -n "$TMP_DIR" -a ! -d "$TMP_DIR" ]
	do
		TMP_DIR="/tmp/$_PREFIX.${RANDOM}${RANDOM}${RANDOM}"
	done
	mkdir -p -m 0700 $TMP_DIR || {
		echo "FATAL: Failed to create temp dir '$TMP_DIR': $?"
		exit 100
	}
	TMP_FILE="$TMP_DIR/$_PREFIX.${RANDOM}${RANDOM}${RANDOM}"
	touch $TMP_FILE && chmod 0600 $TMP_FILE || {
		echo "FATAL: Failed to create temp file '$TMP_FILE': $?"
		exit 101
	}
	# Do our best to clean up temp files no matter what
	# Note $temp_dir must be set before this, and must not change!
	declare -g CLEANUP="rm -rf $TMP_DIR"
	trap "$CLEANUP" ABRT EXIT HUP INT QUIT
}

### apt & friends ##############################################################
add_ppa(){
	local _METHOD=$1
	local _URL=$2
	local _KEY=$3
	case $_METHOD in
		"wget"		)	wget -q -a "$LOGFILE" $_URL -O- | apt-key add - ;;
		"apt-key"	)	apt-key adv --keyserver $_URL --recv-keys $_KEY 2>&1 | verb_line ;;
		"aar"		)	add-apt-repository $_URL 2>&1 | verb_line ;;
	esac
}
apt_inst() { ### Installs packages (space seperated arguments)
	apt-get -qqy --allow-unauthenticated install "$@" 2>&1 | verb_line
}
install() {
	local _PACKAGE=$1
	dpkg -i $_PACKAGE 2>&1 | verb_line
}

### (Inter)net(work) Operations ################################################
download() { ### downloads quietly, output to $LOGFILE
	local _URL=$1
	wget -q -a "$LOGFILE" -nv $_URL
}
