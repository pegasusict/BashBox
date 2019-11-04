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
    local -r LIB="file"
    add_line_to_file() {	import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    edit_lint_in_file() {	import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    add_to_script() {		import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    create_dir() {		import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    create_file() {		import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    create_logfile() {		import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    file_exists() {		import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    go_home() {			import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
    purge_dir() {		import_lib ${LIB} ; ${FUNCNAME[0]} $@; }
}
