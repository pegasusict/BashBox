#!/bin/bash
############################################################################
# Pegasus' Linux Administration Tools #		Pegasus' Bash Function Library #
# (C)2017-2018 Mattijs Snepvangers	  #				 pegasus.ict@gmail.com #
# License: MIT						  #	Please keep my name in the credits #
############################################################################

#########################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools"	#
# SCRIPT_TITLE="Library Index"							#
# MAINTAINER="Mattijs Snepvangers"						#
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"				#
# VERSION_MAJOR=0										#
# VERSION_MINOR=0										#
# VERSION_PATCH=48										#
# VERSION_STATE="PRE-ALPHA"								#
# VERSION_BUILD=20180613								#
# LICENSE="MIT"											#
#########################################################

### FUNCTIONS ###
MAINTENANCE_SCRIPT="maintenance.sh"
MAINTENANCE_SCRIPT_TITLE="Maintenance Script"
CONTAINER_SCRIPT="maintenance_container.sh"
CONTAINER_SCRIPT_TITLE="Container Maintenance Script"
################################################################################

create_constants() { ### defines constants
	if [ $VERBOSITY=5 ] ; then echo "creating constants" ; fi
	declare -agr PLAT_MODULES=("PLAT_Manager" "PLAT_WordPressTools" "PBFL" "PLAT_internet_watchdog" "PLAT_aptcacher")
	declare -agr LIB_PARTS=("apt" "datetime" "file" "install" "mutex" "net" "sed" "term" "tmp" "tmpl" "user" "vars")
	### today's date
	declare -gr TODAY=$(date +"%d-%m-%Y")
	### declare extensions
	declare -gr INI_EXT=".ini"
	declare -gr LIB_EXT=".inc.bash"
	declare -gr LOG_EXT=".log"
	### declare directories !!! always end with a "/" !!!
	declare -gr LOG_DIR="LOGS"
	declare -gr LIB_DIR="PBFL/"
	declare -gr LIB_PREFIX="pbfl-"
	declare -gr SYS_LIB_DIR="/var/lib/plat/"
	declare -gr SYS_BIN_DIR="/usr/bin/plat/"
	declare -gr SYS_CFG_DIR="/etc/plat/"
	declare -gr SYS_LOG_DIR="/var/log/plat/"
	### declare ini & dedicated function lib
	declare -gr INI_FILE="$SCRIPT$INI_EXT"
	declare -gr INI_PRSR="$LIB_DIRini_parser$LIB_EXT"
	declare -gr LIB_FILE="functions$LIB_EXT"
	declare -gr LIB="$LIB_DIR$LIB_FILE"
	declare -gr LOG_FILE="$LOG_DIR$SCRIPT_$$TODAY$LOG_EXT"

	# define booleans
	declare -gr TRUE=0
	declare -gr FALSE=1
	declare -gr LOG_WIDTH=100
	if [ $VERBOSITY=5 ] ; then echo "constants created" ; fi
}

import() {
	local _FILE="$1"
	if [[ -f "$_FILE" ]]
	then
		source "$_FILE"
	else
		>&2 echo "File $_FILE not found!"
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
		>&2 echo "File $_PART not found!"
		exit 1
	fi
	local _TO_BE_IMPORTED="$PEG_LIB$_PART	local _TO_BE_IMPORTED=$PEG_LIB$_PART$LIB_EXT"
	echo "importing $_TO_BE_IMPORTED"
	echo "importing $_TO_BE_IMPORTED"
	import "$_TO_BE_IMPORTED"
	done
	import "$INI_PRSR"
}

### MAIN ###
create_constants
import_libs
