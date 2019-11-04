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
    local -r LIB="dialog"
#    dialog_init() {		import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    dialog_msg_box() {		import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    dialog_yn() {		import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    dialog_menu() {		import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    dialog_radiolist() {	import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    dialog_checklist() {	import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
}
