#!/bin/bash
############################################################################
# Pegasus' Linux Administration Tools #					LXC command module #
# (C)2017-2018 Mattijs Snepvangers	  #				 pegasus.ict@gmail.com #
# License: MIT						  # Please keep my name in the credits #
############################################################################

#######################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools" #
# SCRIPT_TITLE="LXC command module"					  #
# MAINTAINER="Mattijs Snepvangers"					  #
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"			  #
# VERSION_MAJOR=0									  #
# VERSION_MINOR=1									  #
# VERSION_PATCH=0									  #
# VERSION_STATE="ALPHA"								  #
# VERSION_BUILD="20180705"							  #
# LICENSE="MIT"										  #
#######################################################

# mod: LXC command module
# txt: This script is contains functions used in conjunction with LXC/LXD

# fun: lxc_rename
# txt: stop the container, renames it and starts it again
# use: lxc_rename OLD_NAME NEW_NAME
# opt: OLD_NAME: current name of the container
# opt: NEW_NAME: new name of the container
# api: lxc
lxc_rename() {
	local _OLD_NAME	;	_OLD_NAME=$1
	local _NEW_NAME	;	_NEW_NAME=$2
	lxc stop "$_OLD_NAME"
	lxc move "$_OLD_NAME" "$_NEW_NAME"
	lxc start "$_NEW_NAME"
}

check_cont_name() {
	local _CONT_NAME="$1"
	local _FILTERED_NAME=$(echo "$_CONT_NAME" | grep -Po "^[a-zA-Z][-a-zA-Z0-9]{0,61}[a-zA-Z0-9]$")
	if [ $_FILTERED_NAME != $_CONT_NAME ]
	then
		cat <<-EOT
			I'm sorry, the name you proposed is invalid, please enter a valid name:
			    > max 63 chars: -, a-z, A-Z, 0-9
			    > it may not start or end with a dash "-"
			    > it may not start with a digit "0-9""
			EOT
		exit 1
	else
		declare -gr CONT_NAME=$_CONT_NAME
		declare -gr CONT_NAME_VERIFIED=true
	fi
}

create_cont() { ### TODO(pegasusict): WTF is this mess?!
	local _CONT_NAME	;	_CONT_NAME="$1"
	if ![ CONT_NAME_VERIFIED = true ]
	then
		check_cont_name "$_CONT_NAME"
		create_cont "$@"
	fi
	local _START_CONT	;	_START_CONT=$2
	local _CONT_DISTR	;	_CONT_DISTR=$3
	local _CONT_VER		;	_CONT_VER="$4"
	local _COMMAND		;	_COMMAND=
	if [ "$_START_CONT" = true ]
	then
		lxc launch "$_COMMAND"
	else
		lxc init "$_COMMAND"
	fi
	# "$CONT_DISTR":"$CONTAINER_VERSION" "$CONT_NAME"
}

start_cont() {
	_CONT_NAME=$1
	lxc start $_CONT_NAME
}

stop_cont() {
	local _CONT_NAME	;	_CONT_NAME=$1
	lxc stop $_CONT_NAME
}

list_cont() {
	lxc list
}

run_post_install() { ### TODO(pegasusict): ...
	:
}

run_in_container() {
	local _COMMAND		;	_COMMAND="$1"
	local _CONT_NAME	;	_CONT_NAME="$2"
	lxc exec $_CONT_NAME -- $_COMMAND | dbg_line
}

put_in_container() {
	local _FILE			;	_FILE="$1"
	local _CONTAINER	;	_CONTAINER="$2"
	cp "$_FILE" "${LXC_ROOT}${_CONTAINER}"
}

pull_from_container() {
	local _CONTAINER	;	_CONTAINER="$1"
	local _FILE			;	_FILE="$2"
	local _TARGET		;	_TARGET="$3"
	cp "${LXC_ROOT}${_CONTAINER}${_FILE}" "$_TARGET"
}
