#!/bin/bash
############################################################################
# Pegasus' Linux Administration Tools #		Pegasus' Bash Function Library #
# (C)2017-2018 Mattijs Snepvangers	  #				 pegasus.ict@gmail.com #
# License: MIT						  #	Please keep my name in the credits #
############################################################################

#######################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools" #
# SCRIPT_TITLE="Apt Functions Script"				  #
# MAINTAINER="Mattijs Snepvangers"					  #
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"			  #
# VERSION_MAJOR=0									  #
# VERSION_MINOR=1									  #
# VERSION_PATCH=0									  #
# VERSION_STATE="ALPHA"								  #
# VERSION_BUILD=20180621							  #
# LICENSE="MIT"										  #
#######################################################

# fun: add_ppa_key
# txt: installs ppa certificate
# use: add_ppa_key METHOD URL [KEY]
# opt: METHOD: <wget|apt-key|aar>
# opt: URL: the URL of the PPA key
# opt: KEY: code needed when using the apt-key method
# env: LOG_FILE: In case of wget method writes directly to LOG_FILE
# api: pbfl::apt
add_ppa_key() {
	local _METHOD	;	_METHOD=$1
	local _URL		;	_URL=$2
	local _KEY		;	_KEY=$3
	case $_METHOD in
		"wget"		)	wget -q -a "$LOG_FILE" $_URL -O- | apt-key add - ;;
		"apt-key"	)	apt-key adv --keyserver $_URL --recv-keys $_KEY 2>&1 | verb_line ;;
		"aar"		)	add-apt-repository $_URL 2>&1 | verb_line ;;
	esac
}

# fun: apt_inst
# txt: updates all installed packages
# use: apt_inst PACKAGES
# opt: PACKAGES: space separated list of packages to be installed
# api: pbfl::apt
apt_inst() {
	apt-get install --force-yes -y --no-install-recommends -qq --allow-unauthenticated ${packages} 2>&1 | verb_line
	# "$@"
}

# fun: apt_update
# txt: reloads the apt database
# use: apt_update
# api: pbfl::apt
apt_update() {
	info_line "Updating apt cache"
	apt-get -qqy update 2>&1 | verb_line
}

# fun: apt_upgrade
# txt: updates all installed packages
# use: apt_upgrade
# api: pbfl::apt
apt_upgrade() {
	info_line "Updating installed packages"
	apt-get -qqy --allow-unauthenticated upgrade 2>&1 | verb_line
}

# fun: apt_remove
# txt: uninstalls & purges all obsolete packages
# use: apt_remove
# api: pbfl::apt
apt_remove() {
	info_line "Cleaning up obsolete packages"
	apt-get -qqy auto-remove --purge 2>&1 | verb_line
}

# fun: apt_clean
# txt: cleans up apt cache
# use: apt_clean
# api: pbfl::apt
apt_clean() {
	info_line "Clearing old/obsolete package cache"
	apt-get -qqy autoclean 2>&1 | verb_line
}

# fun: apt_cycle
# txt: does a complete update/upgrade/autoremove/clean cycle
# use: apt_cycle
# api: pbfl::apt
apt_cycle() {
	apt_update
	apt_upgrade
	apt_remove
	apt_clean
}

# fun: install
# txt: install a .deb package not available in apt
# use: install <DEB_PACKAGE>
# opt: DEB_PACKAGE: path to file with .deb extension
# api: pbfl::apt
install() {
	local _DEB_PACKAGE	;	_DEB_PACKAGE=$1
	dpkg -i $_DEB_PACKAGE 2>&1 | verb_line
}
