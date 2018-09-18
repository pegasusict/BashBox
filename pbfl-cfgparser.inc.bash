#!/bin/bash
################################################################################
# Pegasus' Linux Administration Tools   #                           CFG Parser #
# (C)2017-2018 Mattijs Snepvangers      #                pegasus.ict@gmail.com #
# License: MIT                          #   Please keep my name in the credits #
################################################################################

################################################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools"
# SCRIPT_TITLE="CFG Parser"
# MAINTAINER="Mattijs Snepvangers"
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"
# VER_MAJOR=0
# VER_MINOR=0
# VER_PATCH=0
# VER_STATE="PRE-ALPHA"
# BUILD="20180918"
# LICENSE="MIT"
################################################################################

# mod: PBFL::CFGparser
# txt: This script is contains functions used for parsing array based CFG files

# fun:
# txt:
# use:
# opt:
# env:
# api:
cfg_parser() {
	for CAT in $CFG_CAT; do

