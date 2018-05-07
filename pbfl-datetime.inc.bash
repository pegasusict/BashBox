#!/bin/bash -p
############################################################################
# Pegasus' Linux Administration Tools #		Pegasus' Bash Function Library #
# (C)2017-2018 Mattijs Snepvangers	  #				 pegasus.ict@gmail.com #
# License: MIT						  #	Please keep my name in the credits #
############################################################################

#######################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools" #
# SCRIPT_TITLE="Datetime Functions Library Script"	  #
# MAINTAINER="Mattijs Snepvangers"					  #
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"			  #
# VERSION_MAJOR=0									  #
# VERSION_MINOR=0									  #
# VERSION_PATCH=1									  #
# VERSION_STATE="STABLE"							  #
# VERSION_BUILD=20180430							  #
# LICENSE="MIT"										  #
#######################################################

get_timestamp() { ### returns something like 2018-03-23_13.37.59.123
	echo $(date +"%Y-%m-%d_%H.%M.%S.%3N")
}
