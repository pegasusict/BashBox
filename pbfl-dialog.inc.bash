#!/bin/bash -p
############################################################################
# Pegasus' Linux Administration Tools #		Pegasus' Bash Function Library #
# (C)2017-2018 Mattijs Snepvangers	  #				 pegasus.ict@gmail.com #
# License: MIT						  #	Please keep my name in the credits #
############################################################################

#######################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools" #
# SCRIPT_TITLE="User Dialog Interaction Script"		  #
# MAINTAINER="Mattijs Snepvangers"					  #
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"			  #
# VERSION_MAJOR=0									  #
# VERSION_MINOR=0									  #
# VERSION_PATCH=0									  #
# VERSION_STATE="PRE-ALPHA"							  #
# VERSION_BUILD=20180508							  #
# LICENSE="MIT"										  #
#######################################################
# reference: http://xmodulo.com/create-dialog-boxes-interactive-shell-script.html

dialog_init() {
	declare -g DIALOG
	# check whether whiptail or dialog is installed
	# (choosing the first command found)
	read DIALOG <<< "$(which whiptail dialog 2> /dev/null)"
	# exit if none found
	[[ "$DIALOG" ]] || {
		crit_line 'neither whiptail nor dialog found'
		exit 1
	}
}

dialog_msgbox() {
	local _TITLE="$1"
	local _MESSAGE="$2"
	local _HEIGHT=$3
	local _WIDTH=$4
	"$DIALOG" --title "<$_TITLE>" --msgbox "<$_MESSAGE>" <"$_HEIGHT"> <"$_WIDTH">
}

dialog_yn() {
	local _TITLE="$1"
	local _MESSAGE="$2"
	local _HEIGHT=$3
	local _WIDTH=$4
	local _RESULT="$5"
	if("$DIALOG" --title "$_TITLE" --yesno "$_MESSAGE" "$_HEIGHT" "$_WIDTH")
	then
		create_var $_RESULT true
	else
		create_var $_RESULT false
	fi
}

dialog_menu() {
	local _TITLE="$1"
	local _MESSAGE="$2"
	local _HEIGHT=$3
	local _WIDTH=$4
	local _MENU_HEIGHT=$5
	local _OPTIONS=$6
	local _ITEMS=""
	local _RESULT=""
	local _ANSWER="$7"
	for K in "${!_OPTIONS[@]}"
	do
		_ITEMS+="\"$K\" \"${MYMAP[$K]}\" "
	done
	_RESULT=$("$DIALOG" --title "$_TITLE" --menu "$_MESSAGE" "$_HEIGHT" "$_WIDTH" $_MENU_HEIGHT $_ITEMS 3>&1 1>&2 2>&3)
	exitstatus=$?
	if [ $exitstatus = 0 ]
	then
		create_var $_ANSWER $_RESULT
		dbg_line "Menu option chosen: $_RESULT"
	else
		err_line "Menu: You chose Cancel."
	fi
}

dialog_radiolist() {
	local _TITLE="$1"
	local _MESSAGE="$2"
	local _HEIGHT=$3
	local _WIDTH=$4
	local _LIST_HEIGHT=$5
	local _OPTIONS=$6
	local _SELECTED=$7
	local _ITEMS=""
	local _RESULT=""
	local _ANSWER="$8"
	for K in "${!_OPTIONS[@]}"
	do
		if [ $_SELECTED = $K ]
		then
			_ITEMS+="\"$K\" \"${MYMAP[$K]}\" ON"
		else
			_ITEMS+="\"$K\" \"${MYMAP[$K]}\" OFF"
		fi
	done
	_RESULT=$("$DIALOG" --title "$_TITLE" --radiolist "$_MESSAGE" "$_HEIGHT" "$_WIDTH" $_LIST_HEIGHT $_ITEMS 3>&1 1>&2 2>&3)
	exitstatus=$?
	if [ $exitstatus = 0 ]
	then
		create_var $_ANSWER $_RESULT
		dbg_line "Radiolist: Option chosen: $_RESULT"
	else
		err_line "Radiolist: You chose Cancel."
	fi
}

dialog_checklist() {
	# mod: Dialog_API
	# fun: dialog_checklist $TITLE $MESSAGE $HEIGHT $WIDTH $LIST_HEIGHT $OPTIONS $SELECTED $ANSWER_ARRAY
	# opt: OPTIONS is an associative array of KEY-VALUE pairs
	# opt: SELECTED is an array of preselected KEYs corresponding to OPTIONS
	# opt: ANSWER is the array created with the results
	# use: declare -A RADIO_OPTIONS=([a]=alpha [b])
	# use: dialog_checklist "A Title" "a message" 10 80 0 
	local _TITLE="$1"
	local _MESSAGE="$2"
	local _HEIGHT=$3
	local _WIDTH=$4
	local _LIST_HEIGHT=$5
	local _OPTIONS=$6
	local _SELECTED=$7
	local _ITEMS=""
	local _RESULT=""
	local _ANSWER="$8"
	local _SELECTED_STRING=" ${_SELECTED[*]} "
	for K in "${!_OPTIONS[@]}"
	do
		if [[ $_SELECTED_STRING =~ " $K " ]]
		then
			_ITEMS+="\"$K\" \"${MYMAP[$K]}\" ON"
		else
			_ITEMS+="\"$K\" \"${MYMAP[$K]}\" OFF"
		fi
	done
	_RESULT=$("$DIALOG" --title "$_TITLE" --radiolist "$_MESSAGE" "$_HEIGHT" "$_WIDTH" $_LIST_HEIGHT $_ITEMS 3>&1 1>&2 2>&3)
	exitstatus=$?
	if [ $exitstatus = 0 ]
	then
		create_indexed_array $_ANSWER $_RESULT
		dbg_line "Checklist: Options chosen: $_RESULT"
	else
		err_line "Checklist: User cancelled."
	fi
}



### MAIN ###
dialog_init
