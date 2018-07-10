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
# VERSION_MINOR=2									  #
# VERSION_PATCH=5									  #
# VERSION_STATE="ALPHA"								  #
# VERSION_BUILD=20180621							  #
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
	### today's date
	declare -gr TODAY=$(date +"%d-%m-%Y")
	### declare extensions
	declare -gr INI_EXT=".ini"
	declare -gr LIB_EXT=".inc.bash"
	declare -gr LOG_EXT=".log"
	### declare prefixes
	declare -gr LIB_PREFIX="pbfl-"
	declare -gr MAINT_PRFX="maintenance-"
	### declare directories !!! always end with a "/" !!!
	declare -gr BASE="plat/"
	declare -gr LIB_DIR="PBFL/"
	declare -gr LOG_DIR="LOGS/"
	declare -gr SYS_BIN_DIR="/usr/bin/$BASE"
	declare -gr SYS_CFG_DIR="/etc/$BASE"
	declare -gr SYS_LIB_DIR="/var/lib/BASE"
	declare -gr SYS_LOG_DIR="/var/log/BASE"
	declare -gr TPL_DIR="templates/"
	### declare ini & dedicated function lib
	declare -gr INI_FILE="${SCRIPT}${INI_EXT}"
	declare -gr INI_PRSR="${LIB_DIR}ini_parser${LIB_EXT}"
	declare -gr FUNC_FILE="${SCRIPT}-functions${LIB_EXT}"
	declare -gr LIB="lib/${LIB_FILE}"
	# define booleans
	declare -gr TRUE=0
	declare -gr FALSE=1
	### log stuff
	declare -gr LOG_WIDTH=100
	declare -gr LOG_FILE="${LOG_DIR}${SCRIPT}_${TODAY}${LOG_EXT}"
	### git stuff
	declare -agr PLAT_REPOSITORIES=("PLAT" "PBFL" "PLAT_aptcacher" "PLAT_container_toolset" "PLAT_internet_watchdog" "PLAT_WordPressTools")
	declare -gr GIT_BASE_URL="https://github.com/pegasusict/"
	declare -gr GIT_EXT=".git"
	#
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
	read_ini() {			import_lib ini		;	read_ini $@				; }
	create_ini() {			import_lib ini		;	create_ini $@			; }

	add_ppa_key() {			import_lib apt		;	add_ppa_key $@			; }
	apt_inst() {			import_lib apt		;	apt_inst $@				; }
	apt_update() {			import_lib apt		;	apt_update				; }
	apt_upgrade() {			import_lib apt		;	apt_upgrade				; }
	apt_remove() {			import_lib apt		;	apt_remove				; }
	apt_clean() {			import_lib apt		;	apt_clean				; }
	apt_cycle() {			import_lib apt		;	apt_cycle				; }
	install() {				import_lib apt		;	install $@				; }

	get_timestamp() {		import_lib datetime	;	get_timestamp			; }

	dialog_init() {			import_lib dialog	;	dialog_init				; }
	dialog_checklist() {	import_lib dialog	;	dialog_checklist $@		; }
	dialog_menu() {			import_lib dialog	;	dialog_menu $@			; }
	dialog_msgbox() {		import_lib dialog	;	dialog_radiolist $@		; }
	dialog_radiolist() {	import_lib dialog	;	dialog_radiolist $@		; }
	dialog_yn() {			import_lib dialog	;	dialog_yn $@			; }

	catch_exit() {			import_lib exit		;	catch_exit $@			; }
	declare_exit_codes() {	import_lib exit		;	declare_exit_codes		; }
	do_exit() {				import_lib exit		;	do_exit $@				; }
	exit_codes_howto() {	import_lib exit		;	exit_codes_howto		; }

	add_line_to_file() {	import_lib file		;	add_line_to_file $@		; }
	edit_line_in_file() {	import_lib file		;	edit_line_in_file $@	; }
	add_to_script() {		import_lib file		;	add_to_script $@		; }
	create_dir() {			import_lib file		;	create_dir $@			; }
	create_file() {			import_lib file		;	create_file $@			; }
	create_logfile() {		import_lib file		;	create_logfile $@		; }
	file_exists() {			import_lib file		;	file_exists $@			; }
	go_home() {				import_lib file		;	go_home					; }
	purge_dir() {			import_lib file		;	purge_dir $@			; }

	header() {				import_lib header	;	header $@				; }
	header_line() {			import_lib header	;	header_line $@			; }
	make_line() {			import_lib header	;	make_line $@			; }

	insert_into_initd() {	import_lib install	;	insert_into_initd $@	; }
	install_mod() {			import_lib install	;	install_mod $@			; }

	lxc_rename() {			import_lib lxc		;	lxc_rename $@			; }

	set_verbosity() {		import_lib log		;	set_verbosity $@		; }
	crit_line() {			import_lib log		;	crit_line $@			; }
	err_line() {			import_lib log		;	err_line $@				; }
	warn_line() {			import_lib log		;	warn_line $@			; }
	info_line() {			import_lib log		;	info_line $@			; }
	dbg_line() {			import_lib log		;	dbg_line $@				; }
	log_line() {			import_lib log		;	log_line $@				; }
	tolog() {				import_lib log		;	tolog $@				; }

	do_mutex() {			import_lib mutex	;	do_mutex $@				; }

	download() {			import_lib net		;	download $@				; }
	cycle_network() {		import_lib net		;	cycle_network $@		; }
	test_DNS() {			import_lib net		;	test_DNS $@				; }
	watch_dog() {			import_lib net		;	watch_dog $@			; }

	in_place() {			import_lib sed		;	in_place $@				; }
	replace_in_file() {		import_lib sed		;	replace_in_file $@		; }
	delete_from_file() {	import_lib sed		;	delete_from_file $@		; }
	append_in_file() {		import_lib sed		;	append_in_file $@		; }

	get_screen_size() {		import_lib term		;	get_screen_size			; }
	gen_colours() {			import_lib term		;	gen_colours $@			; }
	crit_colours() {		import_lib term		;	crit_colours $@			; }
	err_colours() {			import_lib term		;	err_colours $@			; }
	warn_colours() {		import_lib term		;	warn_colours $@			; }
	info_colours() {		import_lib term		;	info_colours $@			; }
	dbg_colours() {			import_lib term		;	dbg_colours $@			; }

	create_tmp() {			import_lib tmp		;	create_tmp $@			; }

	file_from_template() {	import_lib sed		;	file_from_template $@	; }

	version() {				import_lib user		;	version $@				; }
	ask() {					import_lib user		;	ask $@					; }
	prompt() {				import_lib user		;	prompt $@				; }
	choose() {				import_lib user		;	choose $@				; }

	create_var() {			import_lib vars		;	create_var $@			; }
	dup_var() {				import_lib vars		;	dup_var $@				; }
	value_exists() {		import_lib vars		;	value_exists $@			; }
	str_to_lower() {		import_lib vars		;	str_to_lower $@			; }
	str_to_upper() {		import_lib vars		;	str_to_upper $@			; }
}

##### BOILERPLATE #####
create_constants
create_placeholders
