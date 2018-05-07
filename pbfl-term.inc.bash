#!/bin/bash
############################################################################
# Pegasus' Linux Administration Tools #		Pegasus' Bash Function Library #
# (C)2017-2018 Mattijs Snepvangers	  #				 pegasus.ict@gmail.com #
# License: MIT						  # Please keep my name in the credits #
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
# LICENSE="MIT"											#
#########################################################

### FUNCTIONS ###
get_screen_size() { ### gets terminal size and sets global vars
					#+  SCREEN_HEIGHT and SCREEN_WIDTH
	dbg_line "getting screen size"
	declare -g SCREEN_HEIGHT=$(tput lines) #${ $LINES:-25 }
	declare -g SCREEN_WIDTH=$(tput cols) #${ $COLUMNS:-80 }
	dbg_line "Found $SCREEN_HEIGHT lines and $SCREEN_WIDTH columns."
}

gen_colours() { ### These colours are based on the results in Tilda using the Tango colour scheme
	local _COLOUR="$(str_to_lower "$1")"
	local _EFFECTS="$(str_to_lower "$2")"
	local _BG_COLOUR="$(str_to_lower "$3")"
	local _CODEBLOCK_START='\033['
	local _CODEBLOCK_END='m'
	local _TXT_COLOUR=""
	local _TXT_EFFECT=""
	local _TXT_BG=""
	local _RETURN=""

	case $_COLOUR in
		off		)	_TXT_COLOUR=0	;;
		black	)	_TXT_COLOUR=30	;;
		red		)	_TXT_COLOUR=31	;;
		green	)	_TXT_COLOUR=32	;;
		orange	)	_TXT_COLOUR=33	;;
		blue	)	_TXT_COLOUR=34	;;
		fucsia	)	_TXT_COLOUR=35	;;
		cyan	)	_TXT_COLOUR=36	;;
		silver	)	_TXT_COLOUR=37	;;
		grey	)	_TXT_COLOUR=90	;;
		lred	)	_TXT_COLOUR=91	;;
		lgreen	)	_TXT_COLOUR=92	;;
		yellow	)	_TXT_COLOUR=93	;;
		purple	)	_TXT_COLOUR=94	;;
		pink	)	_TXT_COLOUR=95	;;
		lcyan	)	_TXT_COLOUR=96	;;
		white	)	_TXT_COLOUR=97	;; # or 39????
		*		)	_TXT_COLOUR=0	;;
	esac

	case $_EFFECT in
		n|none		)	_TXT_EFFECT=0	;;
		b|bold		)	_TXT_EFFECT=1	;;
		d|dim		)	_TXT_EFFECT=2	;;
		u|under		)	_TXT_EFFECT=4	;;
		h|hidden	)	_TXT_EFFECT=8	;;
		s|strike	)	_TXT_EFFECT=9	;;
		*			)	_TXT_EFFECT=0	;;
	esac

	case $_BG_COLOUR in
		black		)	_TXT_BG=40	;;
		red			)	_TXT_BG=41	;;
		green		)	_TXT_BG=42	;;
		orange		)	_TXT_BG=43	;;
		blue		)	_TXT_BG=44	;;
		fucsia		)	_TXT_BG=45	;;
		cyan		)	_TXT_BG=46	;;
		silver		)	_TXT_BG=47	;;
		gray		)	_TXT_BG=100	;;
		lred		)	_TXT_BG=101	;;
		lgreen		)	_TXT_BG=102	;;
		yellow		)	_TXT_BG=103	;;
		purple		)	_TXT_BG=104	;;
		pink		)	_TXT_BG=105	;;
		lcyan		)	_TXT_BG=106	;;
		white		)	_TXT_BG=107	;;
		unknown		)	_TXT_BG=49	;; # behaves strangely in my terminal emulator, probably a "tilda" issue
		off			)	_TXT_BG=40	;;
		*			)	_TXT_BG=0	;;
	esac

	if [[ "$_TXT_COLOUR" == 0]]
	then
		_RETURN="$_CODEBLOCK_START0$_CODEBLOCK_END"
		echo -e "$_RETURN"
		break
	else
		if [[ "$_TXT_BG" == 0]]
		then
			_RETURN="$_CODEBLOCK_START"
		else
			_RETURN="$_CODEBLOCK_START$_TXT_BG"
		fi
		if [[ "$_TXT_EFFECT" != 0]]
		then
			_RETURN+="$_TXT_EFFECT"
		fi
		_RETURN+="$_TXT_COLOUR$_CODEBLOCK_END"
	fi
	echo -e "$_RETURN"
}

crit_colors() {
	local _LABEL="$1"
	local _MESSAGE="$2"
	local _OUTPUT="$(gen_colours yellow b red)$_LABEL$(gen_colours off) $(gen_colours red b yellow)$_MESSAGE$(gen_colours off)"
	echo -e "$_OUTPUT"
}
err_colors() {
	local _LABEL="$1"
	local _MESSAGE="$2"
	local _OUTPUT="$(gen_colours orange b black)$_LABEL$(gen_colours off) $(gen_colours black b orange)$_MESSAGE$(gen_colours off)"
	echo -e "$_OUTPUT"
}
warn_colors() {
	local _LABEL="$1"
	local _MESSAGE="$2"
	local _OUTPUT="$(gen_colours red n black)$_LABEL$(gen_colours off) $(gen_colours black n red)$_MESSAGE$(gen_colours off)"
	echo -e "$_OUTPUT"
}
info_colors() {
	local _LABEL="$1"
	local _MESSAGE="$2"
	local _OUTPUT="$(gen_colours black n white)$_LABEL$(gen_colours off) $(gen_colours black n silver)$_MESSAGE$(gen_colours off)"
	echo -e "$_OUTPUT"
}
dbg_colors() {
	local _LABEL="$1"
	local _MESSAGE="$2"
	local _OUTPUT="$(gen_colours black n lgreen)$_LABEL$(gen_colours off) $(gen_colours black n green)$_MESSAGE$(gen_colours off)"
	echo -e "$_OUTPUT"
}
