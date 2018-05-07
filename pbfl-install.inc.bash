#!/bin/bash -p
############################################################################
# Pegasus' Linux Administration Tools #		Pegasus' Bash Function Library #
# (C)2017-2018 Mattijs Snepvangers	  #				 pegasus.ict@gmail.com #
# License: GPL v3					  #	Please keep my name in the credits #
############################################################################

#######################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools" #
# SCRIPT_TITLE="Installation Functions Script"		  #
# MAINTAINER="Mattijs Snepvangers"					  #
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"			  #
# VERSION_MAJOR=0									  #
# VERSION_MINOR=0									  #
# VERSION_PATCH=0									  #
# VERSION_STATE="PRE-ALPHA"							  #
# VERSION_BUILD=20180507							  #
#######################################################

insert_into_initd() {
	#copy to /etc/init.d/
	dbg_line "SCRIPT_DIR: $SCRIPT_DIR"
	dbg_line "SCRIPT: $SCRIPT"
	local _SRC_FILE="$SCRIPT_DIR/$SCRIPT"
	dbg_line "Source File: $_SRC_FILE"
	local _TARGET="/etc/init.d/$SCRIPT"
	dbg_line "Target: $_TARGET"
	dbg_line "Copying $_SRC_FILE to $_TARGET"
	cp "$_SRC_FILE" "$_TARGET"
	# set rights and ownership
	dbg_line "Setting rights and ownership for $_TARGET"
	chmod a+x "$_TARGET"
	chown root "$_TARGET"
	dbg_line "Running update-rc.d"
	update-rc.d "$SCRIPT" defaults
	info_line "Installation of $SCRIPT_TITLE complete"
}


install_mod() {
	mods=(PLAT_Manager PLAT_WordPressTools PBFL PLAT_internet_watchdog PLAT_aptcacher)
	local _MODULE=$1
	create_tmp
	local _OLD_PWD=$(pwd)
	cd $TMP_DIR
	git clone https://github.com/pegasusict/$_MODULE.git
	mv $_MODULE/*.inc.bash "$SYS_LIB_DIR"
	mv $_MODULE/*.ini "$SYS_ETC_DIR"
	mv $_MODULE/*.inc.bash "$SYS_LIB_DIR"
}
