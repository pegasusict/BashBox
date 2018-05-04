#!/bin/bash -p
############################################################################
# Pegasus' Linux Administration Tools #		Pegasus' Bash Function Library #
# (C)2017-2018 Mattijs Snepvangers	  #				 pegasus.ict@gmail.com #
# License: GPL v3					  #	Please keep my name in the credits #
############################################################################

#######################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools" #
# SCRIPT_TITLE="Apt Functions Script"				  #
# MAINTAINER="Mattijs Snepvangers"					  #
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"			  #
# VERSION_MAJOR=0									  #
# VERSION_MINOR=0									  #
# VERSION_PATCH=0									  #
# VERSION_STATE="PRE-ALPHA"							  #
# VERSION_BUILD=20180425							  #
#######################################################

### apt & friends ##############################################################
add_ppa(){
	local _METHOD=$1
	local _URL=$2
	local _KEY=$3
	case $_METHOD in
		"wget"		)	wget -q -a "$LOG_FILE" $_URL -O- | apt-key add - ;;
		"apt-key"	)	apt-key adv --keyserver $_URL --recv-keys $_KEY 2>&1 | verb_line ;;
		"aar"		)	add-apt-repository $_URL 2>&1 | verb_line ;;
	esac
}
apt_inst() { ### Installs packages (space seperated arguments)
	apt-get -qqy --allow-unauthenticated install "$@" 2>&1 | verb_line
}
install() {
	local _PACKAGE=$1
	dpkg -i $_PACKAGE 2>&1 | verb_line
}
