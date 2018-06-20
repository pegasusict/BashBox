#!/bin/bash
############################################################################
# Pegasus' Linux Administration Tools #		Pegasus' Bash Function Library #
# (C)2017-2018 Mattijs Snepvangers	  #				 pegasus.ict@gmail.com #
# License: MIT						  #	Please keep my name in the credits #
############################################################################

#######################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools" #
# SCRIPT_TITLE="Header Generator Script"			  #
# MAINTAINER="Mattijs Snepvangers"					  #
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"			  #
# VERSION_MAJOR=0									  #
# VERSION_MINOR=1									  #
# VERSION_PATCH=4									  #
# VERSION_STATE="PRE-ALPHA"							  #
# VERSION_BUILD=20180619							  #
# LICENSE="MIT"										  #
#######################################################

# mod: pbfl::header
# txt: This script contains functions to generate headers & lines

# fun: header
# txt: generates a complete header
# use: header [$CHAR [$LEN [$SPACER]]]
# opt: $CHAR: defaults to "#"
# opt: $LEN: defaults to 80
# opt: $SPACER: defaults to " "
# api: pbfl::header
header() {
	local _CHAR		;	_CHAR=${1:-#}
	local _LEN		;	_LEN=${2:-80}
	local _SPACER	;	_SPACER=${2:-" "}
	local _HEADER	;	_HEADER=$(make_line "$_CHAR" "$_LEN")
	_HEADER+=$(header_line "$PROGRAM_SUITE" "$SCRIPT_TITLE" "$_CHAR" "$_LEN" "$_SPACER")
	_HEADER+=$(header_line "$COPYRIGHT" "$MAINTAINER_EMAIL" "$_CHAR" "$_LEN" "$_SPACER")
	_HEADER+=$(header_line "$SHORT_VERSION" "Build $VERSION_BUILD" "$_CHAR" "$_LEN" "$_SPACER")
	_HEADER+=$(header_line "License: $LICENSE" "Please keep my name in the credits" "$_CHAR" "$_LEN" "$_SPACER")
	_HEADER+="\n$(make_line $_CHAR $_LEN)"
	printf "%s\n" $_HEADER
}

# fun: header_line
# txt: generates a headerline, eg: # <MAINTAINER>             <MAINTAINEREMAIL> #
# use: header_line  $PART1 $PART2 [$CHAR [$LEN [$SPACER]]]
# opt: $CHAR: defaults to "#"
# opt: $LEN: defaults to 80
# opt: $SPACER: defaults to " "
# api: pbfl::header::internal
header_line() {
	local _PART1		;	_PART1="$1"
	local _PART2		;	_PART2="$2"
	local _CHAR			;	_CHAR=${3:-#}
	local _LEN			;	_LEN=${4:-}
	local _SPACER		;	_SPACER=${5:-" "}
	local _SPACERS		;	_SPACERS=""
	local _HEADER_LINE	;	_HEADER_LINE="${_CHAR} ${_PART1}${_SPACERS}${_PART2} ${_CHAR}"
	local _SPACERS_LEN	;	_SPACERS_LEN=(MAX_WIDTH-{#_HEADER_LINE})
	_SPACERS=$( printf "%0.s$_SPACER" $( seq 1 $_SPACERS_LEN ) )
	_HEADER_LINE="${_CHAR} ${_PART1}${_SPACERS}${_PART2} ${_CHAR}"
	printf "%s\n" "$_HEADER_LINE"
}

# fun: make_line
# txt: generates a line
# use: make_line [$CHAR [$LEN]]
# opt: $CHAR: defaults to "#"
# opt: $LEN: defaults to 80
# api: pbfl::header
make_line() {
	local _CHAR		;	_CHAR=${1:-#}
	local _LEN		;	_LEN=${2:-80}
	local _LINE		;	_LINE=$( printf "%0.s$_CHAR" $( seq 1 $_LEN ) )
	printf "%s\n" "$_LINE"
}
