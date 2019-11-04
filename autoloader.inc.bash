#!/bin/bash
####################################################################################
# Pegasus' Linux Administration Tools	#				PBFL Index #
# (C)2017-2018 Mattijs Snepvangers	#		     pegasus.ict@gmail.com #
# License: MIT				#	Please keep my name in the credits #
####################################################################################

####################################################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools"
# SCRIPT_TITLE="PBFL Index Autoloader"
# MAINTAINER="Mattijs Snepvangers"
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"
# VER_MAJOR=1
# VER_MINOR=0
# VER_PATCH=0
# VER_STATE="ALPHA"
# BUILD="20191104"
# LICENSE="MIT"
####################################################################################

# mod: PBFL Index
# txt: This script creates placeholders using the files in the autoload directory
#      for all functions present in PBFL to allow for dynamic loading
# fun: create_placeholders
# txt: Creates placeholders for all functions defined in the library.
#      If one is invoked, the corresponding library class will be imported so
#      the placeholders of the functions belonging to that particular class will
#      be overwritten in memory and then the function call will be repeated.
# use: create_placeholders
# api: pbfl
create_placeholders() {
	for _FILE in $(ls autoload/ -Q); do
	    if [ -f "$_FILE" ]; then
		source "$_FILE"
		autoload_register
	    fi
	done
}

### BOILERPLATE ###
create_placeholders
