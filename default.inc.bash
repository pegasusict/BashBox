#!/bin/bash
############################################################################
# Pegasus' Linux Administration Tools #		Pegasus' Bash Function Library #
# (C)2017-2018 Mattijs Snepvangers	  #				 pegasus.ict@gmail.com #
# License: GPL v3					  # Please keep my name in the credits #
############################################################################

#########################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools"	#
# SCRIPT_TITLE="Library Index"							#
# MAINTAINER="Mattijs Snepvangers"						#
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"				#
# VERSION_MAJOR=0										#
# VERSION_MINOR=0										#
# VERSION_PATCH=30										#
# VERSION_STATE="PRE-ALPHA"								#
# VERSION_BUILD=20180425								#
#########################################################

unset CDPATH # to prevent mishaps when using cd with relative paths

### FUNCTIONS ###
create_constants() {
	# declare extensions
	declare -gr INI_EXT=".ini"
	declare -gr LIB_EXT=".inc.bash"
	declare -gr LOG_EXT=".log"
	# declare directories !!! always end with a "/" !!!
	declare -gr LIB_DIR="BASH_FUNC_LIB/"
	declare -gr PEG_LIB="pbfl-"
	declare -gr SYS_LIB_DIR="/var/lib/plat/"
	declare -gr SYS_BIN_DIR="/usr/bin/plat/"
	declare -gr LOG_DIR="/var/log/plat/"
	# declare ini & dedicated function lib
	declare -gr INI_FILE="$SCRIPT$INI_EXT"
	declare -gr INI_PRSR="$LIB_DIRini_parser$LIB_EXT"
	declare -gr LIB_FILE="functions$LIB_EXT"
	declare -gr LIB="$LIB_DIR$LIB_FILE"
	declare -gr LOG_FILE="$LOGDIR/$SCRIPT_$START_TIME$LOG_EXT"
	# today's date
	declare -gr TODAY=$(date +"%d-%m-%Y")
	# define booleans
	declare -gr TRUE=0
	declare -gr FALSE=1
}
import() {
	local _FILE="$1"
	if [[ -f "$_FILE" ]]
	then
		source "$_FILE"
	else
		crit_line "File $_FILE not found!"
		exit 1
	fi
}
import_libs() {
	echo "importing libs...."
	declare -a _LIB_PARTS=("apt" "datetime" "file" "net" "term" "tmp" "tmpl" "user" "vars")
	for _PART in $_LIB_PARTS
	do
		local _TO_BE_IMPORTED="$PEG_LIB$_PART$LIB_EXT"
		echo "importing $_TO_BE_IMPORTED"
		import "$_TO_BE_IMPORTED"
	done
	import "$INI_PRSR"
}

### MAIN ###
create_constants
import_libs
