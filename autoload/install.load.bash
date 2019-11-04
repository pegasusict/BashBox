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
    local -r LIB="install"
    insert_into_initd() {	import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    install_PLAT() {		import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    install_mod() {		import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    update_PLAT() {		import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
}
