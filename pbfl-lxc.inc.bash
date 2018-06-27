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
# VERSION_MINOR=0									  #
# VERSION_PATCH=0									  #
# VERSION_STATE="PRE-ALPHA"							  #
# VERSION_BUILD="20180627"							  #
# LICENSE="MIT"										  #
#######################################################

# mod: LXC command module
# txt: This script is contains functions ....

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
