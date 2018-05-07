#!/bin/bash
############################################################################
# Pegasus' Linux Administration Tools #		Pegasus' Bash Function Library #
# (C)2017-2018 Mattijs Snepvangers	  #				 pegasus.ict@gmail.com #
# License: MIT						  #	Please keep my name in the credits #
############################################################################

#######################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools" #
# SCRIPT_TITLE="(Inter)Net(work) Functions Script"	  #
# MAINTAINER="Mattijs Snepvangers"					  #
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"			  #
# VERSION_MAJOR=0									  #
# VERSION_MINOR=0									  #
# VERSION_PATCH=15									  #
# VERSION_STATE="ALPHA"								  #
# VERSION_BUILD=20180507							  #
# LICENSE="MIT"										  #
#######################################################

### (Inter)net(work) Operations ################################################
download() { ### downloads quietly, output to $LOG_FILE
	local _URL=$1
	wget -q -a "$LOG_FILE" -nv $_URL
}

cycle_network() {
	dbg_line "cycle_network: resetting network"
	ifdown --exclude=lo -a && ifup --exclude=lo -a 
}

test_DNS() {
	dbg_line "test_DNS: testing DNS"
	local _SERVER="$1"
	# Checking for the resolved IP address from the end of the command output. Refer
	# the normal command output of nslookup to understand why.
	local _RESOLVED_IP=$(nslookup "$_SERVER" | awk -F':' '/^Address: / { matched = 1 } matched { print $2}' | xargs)
	# Deciding the lookup status by checking the variable has a valid IP string
	dbg_line "test_DNS: nslookup $_SERVER yielded $_RESOLVED_IP"
	if [[ -z "$_RESOLVED_IP" ]]
	then
		declare -g DNS_STATE="false"
		dbg_line "test_DNS: DNS DOWN"
	else
		declare -g DNS_STATE="true"
		dbg_line "test_DNS: DNS OK"
	fi
}

watch_dog() {
	local _TEST_SERVER="$1"
	dbg_line "watch_dog: commencing DNS testing"
	while true
	do
		test_DNS "$_TEST_SERVER"
		if [ "$DNS_STATE" == "false" ]
		then
			err_line "watch_dog: DNS Down, resetting network"
			cycle_network
		else
			info_line "watch_dog: DNS works fine"
		fi
		dbg_line "watch_dog: Back in 1 minute"
		sleep 60
	done
}
