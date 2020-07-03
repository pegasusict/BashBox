#!/bin/bash
################################################################################
# Pegasus' Linux Administration Tools  #             ArgParse module #
# (C)2017-2018 Mattijs Snepvangers    #         pegasus.ict@gmail.com #
# License: MIT              #  Please keep my name in the credits #
################################################################################

################################################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools"
# SCRIPT_TITLE="Arguments Parser"
# MAINTAINER="Mattijs Snepvangers"
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"
# VER_MAJOR=0
# VER_MINOR=0
# VER_PATCH=4
# VER_STATE="ALPHA"
# BUILD=20180807
# LICENSE="MIT"
################################################################################

# mod: ArgParse
# txt: This script is contains functions to parse commandline arguments

# fun: arg_parse
#
#
#
arg_parse() {
  local _OPTIONS    ;  _OPTIONS="hv:$1"
  local _LONG_OPTIONS  ;  _LONG_OPTIONS="help,verbosity:,$2"
  PARSED=$(getopt -o $_OPTIONS --long $_LONG_OPTIONS -n "$COMMAND" -- $ARGS)
  if [ $? -ne 0 ]
    then usage
  fi
}

# fun: getopt_test
# txt: tests wether getopt is available and the correct version
# use: getopt_test
# api: argparse
getopt_test() {
  #dbg_pause
  getopt --test > /dev/null
  if [[ $? -ne 4 ]]
  then
    err_line "I’m sorry, \"getopt --test\" failed in this environment."
    exit 1
  fi
  #dbg_restore
}
