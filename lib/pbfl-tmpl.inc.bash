#!/bin/bash
################################################################################
# Pegasus' Linux Administration Tools  #      BashFrame #
# (C)2017-2018 Mattijs Snepvangers    #         pegasus.ict@gmail.com #
# License: MIT              #  Please keep my name in the credits #
################################################################################

################################################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools"
# SCRIPT_TITLE="Template Functions Script"
# MAINTAINER="Mattijs Snepvangers"
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"
# VER_MAJOR=0
# VER_MINOR=0
# VER_PATCH=7
# VER_STATE="PRE-ALPHA"
# BUILD=20180710
# LICENSE="MIT"
################################################################################

################################################################################
file_from_template() { ### render a template file
          # expand variables + preserve formatting
          #usage: create_file_from_template $TARGET_FILE $TEMPLATE
  local _TARGET_FILE=$1
  local _TEMPLATE=$2
  eval "echo \"$(cat $_TEMPLATE)\"" > $_TARGET_FILE
}
################################################################################
