#!/bin/bash
############################################################################
# Pegasus' Linux Administration Tools #		Pegasus' Bash Function Library #
# (C)2017-2018 Mattijs Snepvangers	  #				 pegasus.ict@gmail.com #
# License: GPL v3					  #	Please keep my name in the credits #
############################################################################

#######################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools" #
# SCRIPT_TITLE="(Inter)Net(work) Functions Script"	  #
# MAINTAINER="Mattijs Snepvangers"					  #
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"			  #
# VERSION_MAJOR=0									  #
# VERSION_MINOR=0									  #
# VERSION_PATCH=1									  #
# VERSION_STATE="ALPHA"								  #
# VERSION_BUILD=20180425							  #
#######################################################

### (Inter)net(work) Operations ################################################
download() { ### downloads quietly, output to $LOGFILE
	local _URL=$1
	wget -q -a "$LOGFILE" -nv $_URL
}
