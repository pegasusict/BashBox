#!/bin/bash
################################################################################
# Pegasus' Linux Administration Tools	#					   ArgParse module #
# (C)2017-2018 Mattijs Snepvangers		#				 pegasus.ict@gmail.com #
# License: MIT							#	Please keep my name in the credits #
################################################################################

################################################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools"
# SCRIPT_TITLE="Arguments Parser"
# MAINTAINER="Mattijs Snepvangers"
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"
# VER_MAJOR=0
# VER_MINOR=0
# VER_PATCH=0
# VER_STATE="PRE-ALPHA"
# BUILD="20180803"
# LICENSE="MIT"
################################################################################

# mod: ArgParse
# txt: This script is contains functions to parse commandline arguments

# fun: getopt_test
# txt: tests wether getopt is available and up-to-date
# use: getopt_test
# api: argparse
getopt_test() {
	getopt --test > /dev/null
	if [[ $? -ne 4 ]]
	then
		err_line "I’m sorry, \"getopt --test\" failed in this environment."
		exit 1
	fi
}
