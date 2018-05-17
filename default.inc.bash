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
# VERSION_PATCH=37										#
# VERSION_STATE="ALPHA"									#
# VERSION_BUILD=20180507								#
#########################################################

unset CDPATH # to prevent mishaps when using cd with relative paths
# A better class of script...
set -o errexit		# Exit on most errors (see the manual)
set -o errtrace		# Make sure any error trap is inherited
set -o nounset		# Disallow expansion of unset variables
set -o pipefail		# Use last non-zero exit code in a pipeline
set -o xtrace		# Trace the execution of the script (debug)

### FUNCTIONS ###
create_constants() { ### defines constants
	dbg_line "creating constants"
	declare -agr PLAT_MODULES=("PLAT_Manager" "PLAT_WordPressTools" "PBFL" "PLAT_internet_watchdog" "PLAT_aptcacher")
	declare -agr LIB_PARTS=("apt" "datetime" "file" "install" "net" "term" "tmp" "tmpl" "user" "vars")
	# today's date
	declare -gr TODAY=$(date +"%d-%m-%Y")
	# declare extensions
	declare -gr INI_EXT=".ini"
	declare -gr LIB_EXT=".inc.bash"
	declare -gr LOG_EXT=".log"
	# declare directories !!! always end with a "/" !!!
	declare -gr LIB_DIR="BASH_FUNC_LIB/"
	declare -gr PEG_LIB="pbfl-"
	#declare -gr SYS_LIB_DIR="/var/lib/plat/"
	declare -gr SYS_BIN_DIR="/usr/bin/plat/"
	declare -gr LOG_DIR="/var/log/plat/"
	# declare ini & dedicated function lib
	declare -gr INI_FILE="$SCRIPT$INI_EXT"
	declare -gr INI_PRSR="$LIB_DIRini_parser$LIB_EXT"
	declare -gr LIB_FILE="functions$LIB_EXT"
	declare -gr LIB="$LIB_DIR$LIB_FILE"
	declare -gr LOG_FILE="$LOG_DIR$SCRIPT_$$TODAY$LOG_EXT"

	# define booleans
	declare -gr TRUE=0
	declare -gr FALSE=1
	declare -gr LOG_WIDTH=100
	dbg_line "constants created"
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
	local _PART=""
	local _TO_BE_IMPORTED=""
	for _PART in $LIB_PARTS
	do
	if [[ -f "$LOCAL_LIB$_PART" ]]
	then
		source "$LOCAL_LIB$_PART"
	elif [[ -f "$SYS_LIB_DIR$_PART" ]]
	then
		source "$SYS_LIB_DIR$_PART"
	else
		crit_line "File $_PART not found!"
		exit 1
	fi
	local _TO_BE_IMPORTED="$PEG_LIB$_PART	local _TO_BE_IMPORTED="$PEG_LIB$_PART$LIB_EXT"
	echo "importing $_TO_BE_IMPORTED"
	echo "importing $_TO_BE_IMPORTED"
	import "$_TO_BE_IMPORTED"
	done
	import "$INI_PRSR"
}

### MAIN ###
create_constants
import_libs
