#!/bin/bash
################################################################################
# Pegasus' Linux Administration Tools	#		Pegasus' Bash Function Library #
# (C)2017-2018 Mattijs Snepvangers		#				 pegasus.ict@gmail.com #
# License: MIT							#	Please keep my name in the credits #
################################################################################

################################################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools"
# SCRIPT_TITLE="Installation Functions Script"
# MAINTAINER="Mattijs Snepvangers"
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"
# VER_MAJOR=0
# VER_MINOR=0
# VER_PATCH=8
# VER_STATE="PRE-ALPHA"
# BUILD=20180710
# LICENSE="MIT"
################################################################################

# mod: pbfl::install
# txt:

# fun: insert_into_initd
# txt: copies source file to /etc/init.d/ and optionally renames it,
#      set rights and ownership and runs update-rc.d to register it to
#      start on boot-time
# use: insert_into_initd SRC_DIR SRC_FILE [TARGET_FILE_NAME]
# opt: var SRC_DIR: source directory - MUST END WITH SLASH "/"!!!
# opt: var SRC_FILE: source file
# opt: var TARGET_FILE_NAME: optional new name for file in /etc/init.d/
# api: pbfl::install
insert_into_initd() {
	local _SRC_DIR	;	_SRC_DIR="$1"
	local _SRC_FILE	;	_SRC_FILE="$2"
	local _TARGET	;	_TARGET="/etc/init.d/$_SRC_FILE"
	dbg_line "insert_into_initd: copying $_SRC_FILE from $_SRC_DIR to $_TARGET"
	cp "${_SRC_DIR}${_SRC_FILE}" "$_TARGET"
	# set rights and ownership
	dbg_line "Setting rights and ownership for $_TARGET"
	chmod a+x "$_TARGET"
	chown root "$_TARGET"
	dbg_line "Running update-rc.d"
	update-rc.d "$_SRC_FILE" defaults
	info_line "Installation of $_SRC_FILE complete"
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
