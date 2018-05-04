#!/bin/bash
############################################################################
# Pegasus' Linux Administration Tools #		Pegasus' Bash Function Library #
# (C)2017-2018 Mattijs Snepvangers	  #				 pegasus.ict@gmail.com #
# License: GPL v3					  # Please keep my name in the credits #
############################################################################

#########################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools"	#
# SCRIPT_TITLE="Terminal Library"						#
# MAINTAINER="Mattijs Snepvangers"						#
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"				#
# VERSION_MAJOR=0										#
# VERSION_MINOR=0										#
# VERSION_PATCH=15										#
# VERSION_STATE="ALPHA"									#
# VERSION_BUILD=20180424								#
#########################################################

### FUNCTIONS ###
get_screen_size() { ### gets terminal size and sets global vars
					#+  SCREEN_HEIGHT and SCREEN_WIDTH
	dbg_line "getting screen size"
	declare -g SCREEN_HEIGHT=$(tput lines)
	declare -g SCREEN_WIDTH=$(tput cols)
	dbg_line "Found $SCREEN_HEIGHT lines and $SCREEN_WIDTH columns."
}

define_colors() {
	# Reset
	Color_Off='\033[0m'			# Text Reset

	# Regular Colors
	Black='\033[0;30m'			# Black
	Red='\033[0;31m'			# Red
	Green='\033[0;32m'			# Green
	Yellow='\033[0;33m'			# Yellow
	Blue='\033[0;34m'			# Blue
	Purple='\033[0;35m'			# Purple
	Cyan='\033[0;36m'			# Cyan
	White='\033[0;37m'			# White

	# Bold
	BBlack='\033[1;30m'			# Black
	BRed='\033[1;31m'			# Red
	BGreen='\033[1;32m'			# Green
	BYellow='\033[1;33m'		# Yellow
	BBlue='\033[1;34m'			# Blue
	BPurple='\033[1;35m'		# Purple
	BCyan='\033[1;36m'			# Cyan
	BWhite='\033[1;37m'			# White

	# Underline
	UBlack='\033[4;30m'			# Black
	URed='\033[4;31m'			# Red
	UGreen='\033[4;32m'			# Green
	UYellow='\033[4;33m'		# Yellow
	UBlue='\033[4;34m'			# Blue
	UPurple='\033[4;35m'		# Purple
	UCyan='\033[4;36m'			# Cyan
	UWhite='\033[4;37m'			# White

	# Background
	On_Black='\033[40m'			# Black
	On_Red='\033[41m'			# Red
	On_Green='\033[42m'			# Green
	On_Yellow='\033[43m'		# Yellow
	On_Blue='\033[44m'			# Blue
	On_Purple='\033[45m'		# Purple
	On_Cyan='\033[46m'			# Cyan
	On_White='\033[47m'			# White

	# High Intensity
	IBlack='\033[0;90m'			# Black
	IRed='\033[0;91m'			# Red
	IGreen='\033[0;92m'			# Green
	IYellow='\033[0;93m'		# Yellow
	IBlue='\033[0;94m'			# Blue
	IPurple='\033[0;95m'		# Purple
	ICyan='\033[0;96m'			# Cyan
	IWhite='\033[0;97m'			# White

	# Bold High Intensity
	BIBlack='\033[1;90m'		# Black
	BIRed='\033[1;91m'			# Red
	BIGreen='\033[1;92m'		# Green
	BIYellow='\033[1;93m'		# Yellow
	BIBlue='\033[1;94m'			# Blue
	BIPurple='\033[1;95m'		# Purple
	BICyan='\033[1;96m'			# Cyan
	BIWhite='\033[1;97m'		# White

	# High Intensity backgrounds
	On_IBlack='\033[0;100m'		# Black
	On_IRed='\033[0;101m'		# Red
	On_IGreen='\033[0;102m'		# Green
	On_IYellow='\033[0;103m'	# Yellow
	On_IBlue='\033[0;104m'		# Blue
	On_IPurple='\033[0;105m'	# Purple
	On_ICyan='\033[0;106m'		# Cyan
	On_IWhite='\033[0;107m'		# White

	# Other effects
	Bold='\033[1m'
	Dim='\033[2m'
	Italic='\033[3m'
	Underline='\033[4m'
	Blink='\033[5m'
	
	Invert='\033[7m'
	Hidden='\033[8m'
	Strikethrough='\033[9m'
}
crit_colors() {
	local _LABEL="$1"
	local _MESSAGE="$2"
	local _OUTPUT="$BIYellow$On_IRed$_LABEL$Color_Off $Red$On_Black$_MESSAGE$Color_Off"
	echo -e "$_OUTPUT"
}
err_colors() {
	local _LABEL="$1"
	local _MESSAGE="$2"
	local _OUTPUT="$BRed$On_Black$_LABEL$Color_Off $Red$On_Black$_MESSAGE$Color_Off"
	echo -e "$_OUTPUT"
}
warn_colors() {
	local _LABEL="$1"
	local _MESSAGE="$2"
	local _OUTPUT="$Red$On_White$_LABEL$Color_Off $Red$On_White$_MESSAGE$Color_Off"
	echo -e "$_OUTPUT"
}
info_colors() {
	local _LABEL="$1"
	local _MESSAGE="$2"
	local _OUTPUT="$Black$On_White$_LABEL$Color_Off $Black$On_White$_MESSAGE$Color_Off"
	echo -e "$_OUTPUT"
}
dbg_colors() {
	local _LABEL="$1"
	local _MESSAGE="$2"
	local _OUTPUT="$Black$On_White$_LABEL$Color_Off $Black$On_Green$_MESSAGE$Color_Off"
	echo -e "$_OUTPUT"
}


### MAIN ###
define_colors
