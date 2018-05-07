#!/bin/bash -p
############################################################################
# Pegasus' Linux Administration Tools #		Pegasus' Bash Function Library #
# (C)2017-2018 Mattijs Snepvangers	  #				 pegasus.ict@gmail.com #
# License: MIT						  #	Please keep my name in the credits #
############################################################################

#######################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools" #
# SCRIPT_TITLE="Template Functions Script"			  #
# MAINTAINER="Mattijs Snepvangers"					  #
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"			  #
# VERSION_MAJOR=0									  #
# VERSION_MINOR=0									  #
# VERSION_PATCH=0									  #
# VERSION_STATE="PRE-ALPHA"							  #
# VERSION_BUILD=20180425							  #
# LICENSE="MIT"										  #
#######################################################

######################################################################################################################
create_file_from_template() { ### render a template file
							  # expand variables + preserve formatting
							  #usage: create_file_from_template $TARGET_FILE $TEMPLATE
	local _TARGET_FILE=$1
	local _TEMPLATE=$2
	eval "echo \"$(cat $_TEMPLATE)\"" > $_TARGET_FILE
}
######################################################################################################################
