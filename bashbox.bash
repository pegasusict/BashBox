#!/bin/env bash
################################################################################
## BashBox - Bash Framework            # Version 0.3.0-DEV, Build 2020-07-02  ##
## https://pegasusict.github.io/bashbox	# © 2017-2020 Mattijs Snepvangers     ##
## License: MIT                        # Please keep my name in the credits   ##
################################################################################

# mod: bashbox bootstrap
# txt: This script initializes BashBox, sets default values, gets environment
#       variables,parses ini/cfg files if present, parses any commandline
#       arguments, initialises logging, initializes mutex if requested, etc...

# fun: create_constants
# txt: creates constants used by the framework
# use: create_constants
# api: bashbox
create_constants() {
  [[ ${VERBOSITY}=5 ]] && echo "creating constants..."
  ### today's date
  declare -gr TODAY=$(date +"%d-%m-%Y")
  declare -gr LOG_DATE=$(date +"%Y%m%d")
  ### declare extensions
  declare -gr SCRIPT_EXT=".sh"
  declare -gr IniExt=".ini"
  declare -gr LIB_EXT=".inc.bash"
  declare -gr LOG_EXT=".log"
  ### declare prefixes
  declare -gr LIB_PREFIX="bb-"
  ### declare directories !!! always end with a "/" !!!
  declare -gr LIB_DIR="libs/"
  declare -gr LOG_DIR="logs/"
  declare -gr TPL_DIR="templates/"
  ### declare ini & dedicated function file
  [[ -f "${Script}${IniExt}" ]] && declare -gr INI_FILE="${Script}${IniExt}"
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
  ###
  [[ ${VERBOSITY}=5 ]] && echo "constants created."
}

# fun: import
# txt: tries to import the file from given location and some standard locations
#      of this suite. If REQUIRED is set to true, script will exit with a
#      CRITICAL ERROR message
# use: import $FILE $DIR [ $REQUIRED ]
# opt: str FILE: filename
# opt: str DIR: directory ( MUST end with slash! )
# opt: bool REQUIRED ( true/false ) if omitted, REQUIRED is set to false
# api: internal
import() {
  dbg_pause
  local _FILE="$1"; local _DIR="$2"; local _REQUIRED="$3"; local _SUCCESS=false
  [[ -z "$_REQUIRED" ]] && _REQUIRED=false
  for LOC in "$_DIR$_FILE" "../$_DIR$_FILE" "$LOCAL_LIB_DIR$_FILE" "../$LOCAL_LIB_DIR$_FILE" "$SYS_LIB_DIR$_FILE"; do
    if [[ -f "$LOC" ]]; then source "$LOC"; _SUCCESS=true; break; fi
  done
  if [[ "$_SUCCESS" = false ]]; then
    if [[ "$_REQUIRED" = true ]]; then
      crit_line "Required file $_FILE not found, aborting!"
    else
      err_line "File $_FILE not found!"
    fi
  fi
  dbg_restore
}

# fun: import_lib
# txt: completes the filenames for the library "classes" and invokes import() --> import LIBDIR/LIBPREFIX-LIB.LIBEXT
# use: import_lib $LIB
# opt: var LIB
# api: pbfl
import_lib() {
  local _LIB=$1
  _LIB="${LIB_PREFIX}${_LIB}${LIB_EXT}"
  import "$_LIB" "$_DIR" true
}

##### BOILERPLATE #####
create_constants
source "autoloader${LIB_EXT}"
