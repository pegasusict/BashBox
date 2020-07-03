#!/bin/bash
################################################################################
# Pegasus' Linux Administration Tools  #      BashFrame #
# (C)2017-2018 Mattijs Snepvangers    #         pegasus.ict@gmail.com #
# License: MIT              #  Please keep my name in the credits #
################################################################################

################################################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools"
# SCRIPT_TITLE="File Operations Functions"
# MAINTAINER="Mattijs Snepvangers"
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"
# VER_MAJOR=0
# VER_MINOR=0
# VER_PATCH=14
# VER_STATE="ALPHA"
# BUILD=20180803
# LICENSE="MIT"
################################################################################

### File operations ####################################################
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
  #  err_line "edit_line_in_file(): Something went wrong"
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
