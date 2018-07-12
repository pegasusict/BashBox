#!/bin/bash
################################################################################
# Pegasus' Linux Administration Tools	#		Pegasus' Bash Function Library #
# (C)2017-2018 Mattijs Snepvangers		#				 pegasus.ict@gmail.com #
# License: MIT							#	Please keep my name in the credits #
# based on https://github.com/rudimeier/bash_ini_parser/					   #
################################################################################

################################################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools"
# SCRIPT_TITLE="INI Parser"
# MAINTAINER="Mattijs Snepvangers"
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"
# VER_MAJOR=0
# VER_MINOR=1
# VER_PATCH=5
# VER_STATE="ALPHA"
# BUILD=20180710
# LICENSE="MIT"
################################################################################

# mod: pbfl ini_parser
# txt: This script is an ini parser/generator
#      It will parse an ini file and export this as $INI_<SECTION>_<KEY>
#      TODO(pegasusict): Will look into a way to do this via an array
#      TODO(pegasusict): develop generator

declare -gA INI

# fun: read_ini
# txt: parses .ini files
# use: read_ini INI_FILE [SECTION] [[--prefix|-p] PREFIX] [[--booleans|-b] [0|1]]
# api: pbfl
read_ini() {
	# Set defaults
	local _BOOLEANS=1
	local _CLEAN_ENV=0
	local _IFS=""
	local _IFS_OLD=""
	local _INI_ALL_SECTION=""
	local _INI_ALL_VARNAME=""
	local _INI_FILE=""
	local _INI_NUMSECTIONS_VARNAME=0
	local _INI_SECTION=""
	local _LINE=""
	local _LINE_NUM=0
	local _SECTION=""
	local _SECTIONS_NUM=0
	local _SWITCH_SHOPT=""
	local _VAL=""
	local _VAR=""
	local _VARNAME=""
	local _VARNAME_PREFIX=INI

	# fun: check_prefix
	# txt: Validates the INI prefix
	# use: check_prefix
	# api: ini_internal
	function check_prefix() {
		if ! [[ "${_VARNAME_PREFIX}" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]
		then
			crit_line "CRITICAL read_ini: invalid prefix '${_VARNAME_PREFIX}'" >&2
			return 1
		fi
	}

	# fun: check_ini_file
	# txt: hcecks if ini file exists and is readable
	# use: check_ini_file
	# api: ini_internal
	function check_ini_file() {
		if [ ! -f "$_INI_FILE" ]
		then
			err_line "ERROR read_ini: '${_INI_FILE}' doesn't exist" >&2
			return 1
		else
			if [ ! -r "$_INI_FILE" ]
			then
				err_line "ERROR read_ini: '${_INI_FILE}' not readable" >&2
			fi
		fi
	}

	# fun: pollute_bash
	# txt: enable some optional shell behavior (shopt)
	# use: pollute_bash
	# api: ini_internal
	function pollute_bash() {
		if ! shopt -q extglob
		then
			_SWITCH_SHOPT="${_SWITCH_SHOPT} extglob"
		fi
		if ! shopt -q nocasematch
		then
			_SWITCH_SHOPT="${_SWITCH_SHOPT} nocasematch"
		fi
		shopt -q -s ${_SWITCH_SHOPT}
	}

	# fun: clean_bash
	# txt: unset all local functions and restore shopt settings before
	#      returning from read_ini()
	# use: clean_bash
	# api: ini_internal
	function cleanup_bash() {
		shopt -q -u ${_SWITCH_SHOPT}
		unset -f check_prefix check_ini_file pollute_bash cleanup_bash
	}

	# {{{ START Deal with command line args
		# {{{ START Options
			# Available options:
			#   --boolean	   Whether to recognise special boolean values: ie for 'yes', 'true'
			#				   and 'on' return 1; for 'no', 'false' and 'off' return 0. Quoted
			#				   values will be left as strings
			#				   Default: on

			#   --prefix=STRING String to begin all returned variables with (followed by '__').
			#				   Default: INI

			#   First non-option arg is filename, second is section name
		while [ $# -gt 0 ]
		do
			case $1 in
				--clean | -c	)	_CLEAN_ENV=1 ;;
				--booleans | -b	)	shift ; _BOOLEANS=$1 ;;
				--prefix | -p	)	shift ; _VARNAME_PREFIX=$1 ;;
				* )					if [ -z "$_INI_FILE" ]
									then
										_INI_FILE=$1
									else
										if [ -z "$_INI_SECTION" ]
										then
											_INI_SECTION=$1
										fi
									fi ;;
			esac
			shift
		done
		if [ -z "$_INI_FILE" ] && [ "${_CLEAN_ENV}" = 0 ]
		then
			echo -e "Usage: read_ini [-c] [-b 0| -b 1]] [-p PREFIX] FILE [SECTION]\n  or   read_ini -c [-p PREFIX]" >&2
			cleanup_bash
			return 1
		fi
		if [ ! check_prefix ]
		then
			cleanup_bash
			return 1
		fi
		_INI_ALL_VARNAME="${_VARNAME_PREFIX}__ALL_VARS"
		_INI_ALL_SECTION="${_VARNAME_PREFIX}__ALL_SECTIONS"
		_INI_NUMSECTIONS_VARNAME="${_VARNAME_PREFIX}__NUMSECTIONS"
		if [ "${_CLEAN_ENV}" = 1 ]
		then
			eval unset "\$${_INI_ALL_VARNAME}"
		fi
		unset ${_INI_ALL_VARNAME}
		unset ${_INI_ALL_SECTION}
		unset ${_INI_NUMSECTIONS_VARNAME}
		if [ -z "$_INI_FILE" ]
		then
			cleanup_bash
			return 0
		fi
		if [ ! check_ini_file ]
		then
			cleanup_bash
			return 1
		fi
		# Sanitise BOOLEANS - interpret "0" as 0, anything else as 1
		if [ "$_BOOLEANS" != "0" ]
		then
			_BOOLEANS=1
		fi
		# }}} END Options

	# }}} END Deal with command line args

	_LINE_NUM=0
	_SECTIONS_NUM=0
	_SECTION=""
	# IFS is used in "read" and we want to switch it within the loop
	_IFS=$' \t\n'
	_IFS_OLD="${_IFS}"
	# we need some optional shell behavior (shopt) but want to restore
	# current settings before returning
	_SWITCH_SHOPT=""
	pollute_bash
	while read -r _LINE || [ -n "$_LINE" ]
	do
		dbg_line "line = $_LINE"
		((_LINE_NUM++))
		# Skip blank lines and comments
		if [ -z "$_LINE" -o "${_LINE:0:1}" = ";" -o "${_LINE:0:1}" = "#" ]
		then
			continue
		fi
		# Section marker?
		if [[ "${_LINE}" =~ ^\[[a-zA-Z0-9_]{1,}\]$ ]]
		then
			# Set SECTION var to name of section (strip [ and ] from section marker)
			_SECTION="${_LINE#[}"
			_SECTION="${_SECTION%]}"
			eval "${_INI_ALL_SECTION}=\"\${${_INI_ALL_SECTION}# } $_SECTION\""
			((_SECTIONS_NUM++))
			continue
		fi
		# Are we getting only a specific section? And are we currently in it?
		if [ ! -z "$_INI_SECTION" ]
		then
			if [ "$_SECTION" != "$_INI_SECTION" ]
			then
				continue
			fi
		fi
		# Valid var/value line? (check for variable name and then '=')
		if ! [[ "${_LINE}" =~ ^[a-zA-Z0-9._]{1,}[[:space:]]*= ]]
		then
			err_line "Invalid line:  ${_LINE_NUM}: $_LINE"
			cleanup_bash
			return 1
		fi
		# split line at "=" sign
		_IFS="="
		read -r _VAR _VAL <<< "${_LINE}"
		_IFS="${_IFS_OLD}"
		# delete spaces around the equal sign (using extglob)
		_VAR="${_VAR%%+([[:space:]])}"
		_VAL="${_VAL##+([[:space:]])}"
		_VAR=$(echo $_VAR)

		# Construct variable name:
		# ${_VARNAME_PREFIX}__$_SECTION__$_VAR
		# Or if not in a section:
		# ${_VARNAME_PREFIX}__$_VAR
		# In both cases, full stops ('.') are replaced with underscores ('_')
		if [ -z "$_SECTION" ]
		then
			_VARNAME=${_VARNAME_PREFIX}__${_VAR//./_}
		else
			_VARNAME=${_VARNAME_PREFIX}__${_SECTION}__${_VAR//./_}
		fi
		eval "${_INI_ALL_VARNAME}=\"\${${_INI_ALL_VARNAME}# } ${_VARNAME}\""
		if [[ "${_VAL}" =~ ^\".*\"$  ]]
		then
			# remove existing double quotes
			_VAL="${_VAL##\"}"
			_VAL="${_VAL%%\"}"
		elif [[ "${_VAL}" =~ ^\'.*\'$  ]]
		then
			# remove existing single quotes
			_VAL="${_VAL##\'}"
			_VAL="${_VAL%%\'}"
		elif [ "$_BOOLEANS" = 1 ]
		then
			# Value is not enclosed in quotes
			# Booleans processing is switched on, check for special boolean
			# values and convert

			# here we compare case insensitive because
			# "shopt nocasematch"
			case "$_VAL" in
				yes | true | on )   _VAL=1 ;;
				no | false | off )  _VAL=0 ;;
			esac
		fi
		# enclose the value in single quotes and escape any
		# single quotes and backslashes that may be in the value
		_VAL="${_VAL//\\/\\\\}"
		_VAL="\$'${_VAL//\'/\'}'"

		eval "$_VARNAME=$_VAL"
	done  <"${_INI_FILE}"

	# return also the number of parsed sections
	eval "$_INI_NUMSECTIONS_VARNAME=$_SECTIONS_NUM"
	cleanup_bash
}

create_ini() {
	:
}
