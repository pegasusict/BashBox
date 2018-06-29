#!/bin/bash
############################################################################
# Pegasus' Linux Administration Tools #		Pegasus' Bash Function Library #
# (C)2017-2018 Mattijs Snepvangers	  #				 pegasus.ict@gmail.com #
# License: MIT						  #	Please keep my name in the credits #
############################################################################

#######################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools" #
# SCRIPT_TITLE="Installation Functions Script"		  #
# MAINTAINER="Mattijs Snepvangers"					  #
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"			  #
# VERSION_MAJOR=0									  #
# VERSION_MINOR=0									  #
# VERSION_PATCH=1									  #
# VERSION_STATE="PRE-ALPHA"							  #
# VERSION_BUILD=20180517							  #
# LICENSE="MIT"										  #
#######################################################

# mod: pbfl::install
# txt:

# fun:add_to_initd
# txt:
# use:
# api: pbfl::install
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


# fun: install_PLAT
# txt: Downloads & installs all PLAT Modules
# use: install_PLAT
# api: pbfl::install
install_PLAT(){
	create_tmp "plat_inst"
	cd "$TMP_DIR"
	#download all repositories
	for _REP in $PLAT_REPOSITORIES
	do
		git clone "${_BASE_URL}${_REP}${_EXT}"
		mv templates/* "${SYS_LIB_DIR}templates/"
		mv */*.inc.bash "$SYS_LIB_DIR"
		mv */*.bash "$SYS_BIN_DIR"
		mv */*.ini "$SYS_CFG_DIR"
	done
}

# fun: install_mod
# txt: Downloads & installs PLAT Modules, one at a time
# use: install_mod MODULE
# opt: MODULE
# api: pbfl::install
install_mod() {
	local _MODULE	;	_MODULE=$1
	local _OLD_PWD	;	_OLD_PWD=$(pwd)
	create_tmp
	cd $TMP_DIR
	git clone "${_BASE_URL}${_MODULE}${_EXT}"
	mv $_MODULE/*.inc.bash "$SYS_LIB_DIR"
	mv $_MODULE/*.ini "$SYS_ETC_DIR"
	cd "$_OLD_PWD"
}

# fun: update_PLAT
# txt: Update the entire PLAT suite
# use: update_PLAT
# api: pbfl::update
update_PLAT() {
	goto_base_dir
	git pull
	for _REP in $PLAT_REPOSITORIES
	do
		if [ "$_REP" = PLAT ]
		then
			:
		else
			cd $_REP
			git pull
			cd ..
		fi
	done
}
