#!/bin/bash
################################################################################
# Pegasus' Linux Administration Tools	#		Pegasus' Bash Function Library #
# (C)2017-2018 Mattijs Snepvangers		#				 pegasus.ict@gmail.com #
# License: MIT							#	Please keep my name in the credits #
################################################################################

################################################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools"
# SCRIPT_TITLE="Library Index"
# MAINTAINER="Mattijs Snepvangers"
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"
# VER_MAJOR=0
# VER_MINOR=2
# VER_PATCH=11
# VER_STATE="ALPHA"
# BUILD=20180806
# LICENSE="MIT"
################################################################################

# mod: pbfl index
# txt: This script is an index for Pegasus' Bash Function Library

# fun: create_constants
# txt: creates constants used by the library
# use: create_constants
# api: pbfl
create_constants() {
	if [ $VERBOSITY=5 ] ; then echo "creating constants..." ; fi
	### today's date
	declare -gr TODAY=$(date +"%d-%m-%Y")
	#declare -gr LOG_DATE=$(date +"%Y%m%d")
	### declare extensions
	declare -gr SCRIPT_EXT=".sh"
	#declare -gr INI_EXT=".ini"
	declare -gr LIB_EXT=".inc.bash"
	#declare -gr LOG_EXT=".log"
	### declare prefixes
	declare -gr LIB_PREFIX="pbfl-"
	declare -gr MAINT_PRFX="maintenance-"
	### declare directories !!! always end with a "/" !!!
	declare -gr LIB_DIR="PBFL/"
	#declare -gr LOG_DIR="logs/"
	declare -gr TPL_DIR="templates/"
	### declare ini & dedicated function lib
	#declare -gr INI_FILE="${SCRIPT}${INI_EXT}"
	#declare -gr INI_PRSR="${LIB_DIR}ini_parser${LIB_EXT}"
	declare -gr FUNC_FILE="${SCRIPT}-functions${LIB_EXT}"
	# define booleans
	declare -gr TRUE=0
	declare -gr FALSE=1
	### log stuff
	#declare -gr LOG_WIDTH=100
	#declare -gr LOG_FILE="${LOG_DIR}${SCRIPT}_${LOG_DATE}${LOG_EXT}"
	### git stuff
	declare -agr PLAT_REPOSITORIES=("PLAT" "PBFL" "PLAT_aptcacher" "PLAT_container_toolset" "PLAT_internet_watchdog" "PLAT_WordPressTools")
	declare -gr GIT_BASE_URL="https://github.com/pegasusict/"
	declare -gr GIT_EXT=".git"

	if [ $VERBOSITY=5 ] ; then echo "constants created." ; fi
}

# fun: import_lib
# txt: completes the filenames for the library "classes" and invokes import() --> import LIBDIR/LIBPREFIX-LIB.LIBEXT
# use: import_lib $LIB $DIR
# opt: var FILE
# opt: var DIR
# opt: bool REQUIRED
# api: pbfl
import_lib() {
	local _LIB	;	_LIB=$1
	_LIB="${LIB_PREFIX}${_LIB}${LIB_EXT}"
	import "$_LIB" "$_DIR" true
}


##### BOILERPLATE #####
create_constants
import "index$LIB_EXT" "$LIB_DIR" true
create_placeholders
