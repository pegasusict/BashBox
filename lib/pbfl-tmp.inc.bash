#!/bin/bash
################################################################################
# Pegasus' Linux Administration Tools  #      BashFrame #
# (C)2017-2018 Mattijs Snepvangers    #         pegasus.ict@gmail.com #
# License: MIT              #  Please keep my name in the credits #
################################################################################

################################################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools"
# SCRIPT_TITLE="TMP dir/file Functions Script"
# MAINTAINER="Mattijs Snepvangers"
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"
# VER_MAJOR=0
# VER_MINOR=0
# VER_PATCH=10
# VER_STATE="PRE-ALPHA"
# BUILD=20180710
# LICENSE="MIT"
################################################################################

### TMP OPS ###
create_tmp() { ### usage: create_tmp $PREFIX
  local _PREFIX=$1
  TMP_DIR=""
  TMP_FILE=""
  until [ -n "$TMP_DIR" -a ! -d "$TMP_DIR" ]
  do
    TMP_DIR="/tmp/$_PREFIX.${RANDOM}${RANDOM}${RANDOM}"
  done
  if [[ !$(mkdir -p -m 0700 $TMP_DIR) ]]
  then
    echo "FATAL: Failed to create temp dir '$TMP_DIR': $?"
    exit 100
  fi
  TMP_FILE="$TMP_DIR/$_PREFIX.${RANDOM}${RANDOM}${RANDOM}"
  if [[ !$(touch $TMP_FILE && chmod 0600 $TMP_FILE) ]]
  then
    echo "FATAL: Failed to create temp file '$TMP_FILE': $?"
    exit 101
  fi
  # Do our best to clean up temp files no matter what
  # Note $temp_dir must be set before this, and must not change!
  declare -g CLEANUP="rm -rf $TMP_DIR"
  trap "$CLEANUP" ABRT EXIT HUP INT QUIT
}
