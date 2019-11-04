#!/bin/bash
################################################################################
# Pegasus' Linux Administration Tools	#		Pegasus' Bash Function Library #
# (C)2017-2018 Mattijs Snepvangers		#				 pegasus.ict@gmail.com #
# License: MIT							#	Please keep my name in the credits #
################################################################################

################################################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools"
# SCRIPT_TITLE="AutoLoader"
# MAINTAINER="Mattijs Snepvangers"
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"
# VER_MAJOR=0
# VER_MINOR=0
# VER_PATCH=0
# VER_STATE="ALPHA"
# BUILD=20191104
# LICENSE="MIT"
################################################################################

# fun: autoload_register
# txt: registers function placeholders which will load the respective library when required
# api: pbfl::internal
autoload_register() {
    local -r LIB="apt"
    apt_cmd() {			import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    apt_cmd_silent() {		import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    add_ppa_key() {		import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    apt_inst_with_recs() {	import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    apt_inst_no_recs() {	import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    apt_update() {		import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    apt_upgrade() {		import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    apt_remove() {		import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    apt_uninstall() {		import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    apt_clean() {		import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    apt_fix_deps() {		import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    install_pkg() {		import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    clean_sources() {		import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    apt_cycle() {		import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    apt_uninstall() {		import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
}
