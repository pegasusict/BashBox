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
    local -r LIB="log"
    set_verbosity() {	import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    crit_line() {	import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    err_line() {	import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    warn_line() {	import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    info_line() {	import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    dbg_line() {	import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    log_line() {	import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    to_log() {		import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    exeqt() {		import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
}
