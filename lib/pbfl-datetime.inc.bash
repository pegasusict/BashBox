#!/bin/bash
################################################################################
# Pegasus' Linux Administration Tools  #      BashFrame #
# (C)2017-2018 Mattijs Snepvangers    #         pegasus.ict@gmail.com #
# License: MIT              #  Please keep my name in the credits #
################################################################################

################################################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools"
# SCRIPT_TITLE="Datetime Class"
# MAINTAINER="Mattijs Snepvangers"
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"
# VER_MAJOR=0
# VER_MINOR=0
# VER_PATCH=8
# VER_STATE="STABLE"
# BUILD=20180710
# LICENSE="MIT"
################################################################################

# fun: get_timestamp
# txt: returns something like 2018-03-23_13.37.59.123
# use: get_timestamp
# api: pbfl::datetime
get_timestamp() {
  echo $(date +"%Y-%m-%d_%H.%M.%S.%3N")
}
