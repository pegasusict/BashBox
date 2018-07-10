#!/bin/bash -p
################################################################################
# Pegasus' Linux Administration Tools	#		Pegasus' Bash Function Library #
# (C)2017-2018 Mattijs Snepvangers		#				 pegasus.ict@gmail.com #
# License: MIT							#	Please keep my name in the credits #
################################################################################

################################################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools"
# SCRIPT_TITLE="Sed Functions Script"
# MAINTAINER="Mattijs Snepvangers"
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"
# VER_MAJOR=0
# VER_MINOR=0
# VER_PATCH=5
# VER_STATE="PRE-ALPHA"
# BUILD=20180710
# LICENSE="MIT"
################################################################################

declare -gr SED_BASE_COMMAND="sed --follow-symlinks --quiet"
declare -gr SED_EXT_REGEX="-E"
declare -gr SED_ZERO_TERM="--zero-terminated"

in_place() { 	### ties everything together and checks if it involves a seperate outputfile or not
	local _COMMAND="$1"
	local _SOURCE="$2"
	local _TARGET="$3"
	if [ -z "$_TARGET" ]
	then
		local _RESULT="$SED_BASE_COMMAND -i '$_COMMAND' '$_SOURCE'"
	else
		local _RESULT="SED_BASE_COMMAND '$_COMMAND' '$_SOURCE' > '$_TARGET'"
	fi
	echo "$_RESULT"
}

replace_in_file() {
	local _SEARCH="$1"
	local _REPLACE_WITH="$2"
	local _SOURCE="$3"
	local _TARGET="$4"
	local _COMMAND="s/$_SEARCH/$_REPLACE_WITH/"
	in_place "$_COMMAND" "$_SOURCE" "$_TARGET"
}

delete_from_file() {
	local _ADDRESS="$1" # can be line no, regex or range of line numbers
	local _SOURCE="$2"
	local _TARGET="$3"
	local _COMMAND="'$_ADDRESS" ; _COMMAND+="d'"
	in_place "$_COMMAND" "$_SOURCE" "$_TARGET"
}

append_in_file() {
	local _ADDRESS="$1" # can be line no, regex or range of line numbers
	local _TEXT="$2"
	local _SOURCE="$3"
	local _TARGET="$4"
	local _COMMAND="'$_ADDRESS" ; _COMMAND+="a $_TEXT'"
	in_place "$_COMMAND" "$_SOURCE" "$_TARGET"
}
