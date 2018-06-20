#!/bin/bash
############################################################################
# Pegasus' Linux Administration Tools #		Pegasus' Bash Function Library #
# (C)2017-2018 Mattijs Snepvangers	  #				 pegasus.ict@gmail.com #
# License: MIT						  #	Please keep my name in the credits #
############################################################################

#######################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools" #
# SCRIPT_TITLE="Library Index"						  #
# MAINTAINER="Mattijs Snepvangers"					  #
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"			  #
# VERSION_MAJOR=0									  #
# VERSION_MINOR=0									  #
# VERSION_PATCH=57									  #
# VERSION_STATE="PRE-ALPHA"							  #
# VERSION_BUILD=20180614							  #
# LICENSE="MIT"										  #
#######################################################

# mod: pbfl index
# txt: This script is an index for Pegasus' Bash Function Library

# fun: create_constants
# txt: creates constants used by the library
# use: create_constants
# api: pbfl
create_constants() {
	if [ $VERBOSITY=5 ] ; then echo "creating constants..." ; fi
	declare -agr LIB_PARTS=("apt" "datetime" "dialog" "exit" "file" "header" "install" "log" "mutex" "net" "sed" "term" "tmp" "tmpl" "user" "vars")
	### today's date
	declare -gr TODAY=$(date +"%d-%m-%Y")
	### declare extensions
	declare -gr INI_EXT=".ini"
	declare -gr LIB_EXT=".inc.bash"
	declare -gr LOG_EXT=".log"
	### declare directories !!! always end with a "/" !!!
	declare -gr LOG_DIR="LOGS/"
	declare -gr LIB_DIR="PBFL/"
	declare -gr LIB_PREFIX="pbfl-"
	declare -gr SYS_LIB_DIR="/var/lib/plat/"
	declare -gr SYS_BIN_DIR="/usr/bin/plat/"
	declare -gr SYS_CFG_DIR="/etc/plat/"
	declare -gr SYS_LOG_DIR="/var/log/plat/"
	### declare ini & dedicated function lib
	declare -gr INI_FILE="${SCRIPT}${INI_EXT}"
	declare -gr INI_PRSR="${LIB_DIR}ini_parser${LIB_EXT}"
	declare -gr LIB_FILE="${SCRIPT}-functions${LIB_EXT}"
	declare -gr LIB="lib/${LIB_FILE}"
	declare -gr LOG_FILE="${LOG_DIR}${SCRIPT}_${TODAY}${LOG_EXT}"
	# define booleans
	declare -gr TRUE=0
	declare -gr FALSE=1
	### misc
	declare -gr LOG_WIDTH=100
	if [ $VERBOSITY=5 ] ; then echo "constants created." ; fi
}

# fun: import_lib
# txt: completes the filenames for the library "classes" and invokes import() --> import LIBDIR/LIBPREFIX-LIB.LIBEXT
# use: import_lib $LIB
# api: pbfl
import_lib() {
	local _LIB	;	_LIB=$1
	_LIB="${LIB_DIR}${LIB_PREFIX}${_LIB}${LIB_EXT}"
	import "$_LIB"
}

# fun: create_placeholders
# txt: Creates placeholders for all functions defined in the library.
#      If one is invoked, the corresponding library class will be imported so
#      the placeholders of the functions belonging to that particular class will
#      be overwritten in memory and then the function call will be repeated.
# use: create_placeholders
# api: pbfl
create_placeholders() {
	read_ini() {			import "$INI_PRSR"	;	$0 $@ }

	add_ppa_key() {			importlib apt		;	$0 $@ }
	apt_inst() {			importlib apt		;	$0 $@ }
	install() {				importlib apt		;	$0 $@ }

	get_timestamp() {		importlib datetime	;	$0 $@ }

	dialog_init() {			importlib dialog	;	$0 $@ }
	dialog_checklist() {	importlib dialog	;	$0 $@ }
	dialog_menu() {			importlib dialog	;	$0 $@ }
	dialog_msgbox() {		importlib dialog	;	$0 $@ }
	dialog_radiolist() {	importlib dialog	;	$0 $@ }
	dialog_yn() {			importlib dialog	;	$0 $@ }

	catch_exit() {			importlib exit		;	$0 $@ }
	declare_exit_codes() {	importlib exit		;	$0 $@ }
	do_exit() {				importlib exit		;	$0 $@ }
	exit_codes_howto() {	importlib exit		;	$0 $@ }

	add_line_to_file() {	importlib file		;	$0 $@ }
	edit_line_in_file() {	importlib file		;	$0 $@ }
	add_to_script() {		importlib file		;	$0 $@ }
	create_dir() {			importlib file		;	$0 $@ }
	create_file() {			importlib file		;	$0 $@ }
	create_logfile() {		importlib file		;	$0 $@ }
	file_exists() {			importlib file		;	$0 $@ }
	goto_base_dir() {		importlib file		;	$0 $@ }
	purge_dir() {			importlib file		;	$0 $@ }

	header() {				importlib header	;	$0 $@ }
	header_line() {			importlib header	;	$0 $@ }
	make_line() {			importlib header	;	$0 $@ }

	insert_into_initd() {	importlib install	;	$0 $@ }
	install_mod() {			importlib install	;	$0 $@ }

	set_verbosity() {		importlib log		;	$0 $@ }
	crit_line() {			importlib log		;	$0 $@ }
	err_line() {			importlib log		;	$0 $@ }
	warn_line() {			importlib log		;	$0 $@ }
	info_line() {			importlib log		;	$0 $@ }
	dbg_line() {			importlib log		;	$0 $@ }
	log_line() {			importlib log		;	$0 $@ }
	tolog() {				importlib log		;	$0 $@ }

	do_mutex() {			importlib mutex		;	$0 $@ }

	download() {			importlib net		;	$0 $@ }
	cycle_network() {		importlib net		;	$0 $@ }
	test_DNS() {			importlib net		;	$0 $@ }
	watch_dog() {			importlib net		;	$0 $@ }

	in_place() {			importlib sed		;	$0 $@ }
	replace_in_file() {		importlib sed		;	$0 $@ }
	delete_from_file() {	importlib sed		;	$0 $@ }
	append_in_file() {		importlib sed		;	$0 $@ }

	get_screen_size() {		importlib term		;	$0 $@ }
	gen_colours() {			importlib term		;	$0 $@ }
	crit_colours() {		importlib term		;	$0 $@ }
	err_colours() {			importlib term		;	$0 $@ }
	warn_colours() {		importlib term		;	$0 $@ }
	info_colours() {		importlib term		;	$0 $@ }
	dbg_colours() {			importlib term		;	$0 $@ }

	create_tmp() {			importlib tmp		;	$0 $@ }

	file_from_template() {	importlib sed		;	$0 $@ }

	version() {				importlib user		;	$0 $@ }
	ask() {					importlib user		;	$0 $@ }
	prompt() {				importlib user		;	$0 $@ }
	choose() {				importlib user		;	$0 $@ }

	create_var() {			importlib vars		;	$0 $@ }
	dup_var() {				importlib vars		;	$0 $@ }
	value_exists() {		importlib vars		;	$0 $@ }
	str_to_lower() {		importlib vars		;	$0 $@ }
	str_to_upper() {		importlib vars		;	$0 $@ }
}

##### BOILERPLATE #####
create_constants
create_placeholders
