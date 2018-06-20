#!/bin/bash
############################################################################
# Pegasus' Linux Administration Tools #		Pegasus' Bash Function Library #
# (C)2017-2018 Mattijs Snepvangers	  #				 pegasus.ict@gmail.com #
# License: MIT						  #	Please keep my name in the credits #
############################################################################

#######################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools" #
# SCRIPT_TITLE="Library Index"						  #
# MAINTAINER="Mattijs Snepvangers"					  #
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"			  #
# VERSION_MAJOR=0									  #
# VERSION_MINOR=0									  #
# VERSION_PATCH=57									  #
# VERSION_STATE="PRE-ALPHA"							  #
# VERSION_BUILD=20180614							  #
# LICENSE="MIT"										  #
#######################################################

# mod: pbfl index
# txt: This script is an index for Pegasus' Bash Function Library

# fun: create_constants
# txt: creates constants used by the library
# use: create_constants
# api: pbfl
create_constants() {
	if [ $VERBOSITY=5 ] ; then echo "creating constants..." ; fi
	declare -agr LIB_PARTS=("apt" "datetime" "dialog" "exit" "file" "header" "install" "log" "mutex" "net" "sed" "term" "tmp" "tmpl" "user" "vars")
	### today's date
	declare -gr TODAY=$(date +"%d-%m-%Y")
	### declare extensions
	declare -gr INI_EXT=".ini"
	declare -gr LIB_EXT=".inc.bash"
	declare -gr LOG_EXT=".log"
	### declare directories !!! always end with a "/" !!!
	declare -gr LOG_DIR="LOGS/"
	declare -gr LIB_DIR="PBFL/"
	declare -gr LIB_PREFIX="pbfl-"
	declare -gr SYS_LIB_DIR="/var/lib/plat/"
	declare -gr SYS_BIN_DIR="/usr/bin/plat/"
	declare -gr SYS_CFG_DIR="/etc/plat/"
	declare -gr SYS_LOG_DIR="/var/log/plat/"
	### declare ini & dedicated function lib
	declare -gr INI_FILE="${SCRIPT}${INI_EXT}"
	declare -gr INI_PRSR="${LIB_DIR}ini_parser${LIB_EXT}"
	declare -gr LIB_FILE="${SCRIPT}-functions${LIB_EXT}"
	declare -gr LIB="lib/${LIB_FILE}"
	declare -gr LOG_FILE="${LOG_DIR}${SCRIPT}_${TODAY}${LOG_EXT}"
	# define booleans
	declare -gr TRUE=0
	declare -gr FALSE=1
	### misc
	declare -gr LOG_WIDTH=100
	if [ $VERBOSITY=5 ] ; then echo "constants created." ; fi
}

check_dependencies() {
	for DEP in "$@"
	do
declare -a __moduleCache=()

module() {
  local path="${1}"
  local export="${2}"
  shift; shift;
  local filename
  if [[ "${path:0:2}" == "./" ]]
  then
    filename="$( cd "${BASH_SOURCE[1]%/*}" && pwd )/${path#\./}"
  else
    # for absolute path we assume it's relative to "SCRIPT_DIR"
    filename="${SCRIPT_DIR}/${path}"
  fi
  load "${filename}.sh" "${export}" "$@"
}

load() {
  local filename="${1}"
  local export="${2}"
  shift; shift;
  local moduleName="_moduleId_${filename//[^a-zA-Z0-9]/_}"
  local moduleId="${!moduleName}"
  if [[ -z "${moduleId}" ]]
  then
    # module not yet loaded
    local moduleId="${#__moduleCache[@]}"
    local moduleContents
    moduleContents=$(<"${filename}")
    local moduleMemberPrefix="__module__${moduleId}"
    local prefixedModule="${moduleContents//__module__/$moduleMemberPrefix}"
    # declares reference to ID in global scope:
    eval ${moduleName}=${moduleId}
    __moduleCache+=($moduleName)
    # execute the module:
    eval "$prefixedModule"
  fi

  # module already loaded, execute
  __module__${moduleId}.${export} "$@"
}
}
# fun: import_libs
# txt: imports all parts of the library
# use: import_libs
# api: pbfl
import_libs() {
	if [ $VERBOSITY=5 ] ; then echo "importing libs..." ; fi
	local _PART=""
	local _TO_BE_IMPORTED=""
	for _PART in "${LIB_PARTS[@]}"
	do
		local _LIB_FILE="${LIB_PREFIX}${_PART}${LIB_EXT}"
		if [[ -f "${LIB_DIR}${_LIB_FILE}" ]]
		then
			echo "importing $_LIB_FILE"
			source "${LIB_DIR}${_LIB_FILE}"
		elif [[ -f "${SYS_LIB_DIR}${_LIB_FILE}" ]]
		then
			source "${SYS_LIB_DIR}${_LIB_FILE}"
		else
			>&2 echo "File $_LIB_FILE not found!"
			exit 1
		fi
	done
	if [ $VERBOSITY=5 ] ; then echo "libs imported." ; fi
}

##### BOILERPLATE #####
create_constants
import_libs
import "$INI_PRSR"
