#!/bin/bash
################################################################################
# Pegasus' Linux Administration Tools	#		Pegasus' Bash Function Library #
# (C)2017-2018 Mattijs Snepvangers		#				 pegasus.ict@gmail.com #
# License: MIT							# Please keep my name in the credits #
################################################################################

################################################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools"
# SCRIPT_TITLE="Terminal Library"
# MAINTAINER="Mattijs Snepvangers"
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"
# VER_MAJOR=0
# VER_MINOR=0
# VER_PATCH=27
# VER_STATE="ALPHA"
# BUILD=20180803
# LICENSE="MIT"
################################################################################

### FUNCTIONS ###
get_screen_size() { ### gets terminal size and sets global vars
					#+  SCREEN_HEIGHT and SCREEN_WIDTH
	#dbg_line "getting screen size"
	declare -g SCREEN_HEIGHT=$(tput lines)
	declare -g SCREEN_WIDTH=$(tput cols)
	#dbg_line "Found $SCREEN_HEIGHT lines and $SCREEN_WIDTH columns."
}

gen_colours() { ### These colours are based on the results in Tilda using the Tango colour scheme
	local _COLOUR="$(str_to_lower "$1")"
	local _EFFECTS="$(str_to_lower "$2")"
	local _BG_COLOUR="$(str_to_lower "$3")"
	local _CODEBLOCK_START='\e['
	local _CODEBLOCK_END='m'
	local _TXT_COLOUR=""
	local _TXT_EFFECT=""
	local _TXT_BG=""
	local _RETURN=""

	if [ "$_COLOUR" == reset ]
	then
		_RETURN="${_CODEBLOCK_START}0${_CODEBLOCK_END}"
		echo -en "$_RETURN"
	else
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
			blink		)	_TXT_EFFECT=5	;;
			i|inverted	)	_TXT_EFFECT=7	;;
			h|hidden	)	_TXT_EFFECT=8	;;
			s|strike	)	_TXT_EFFECT=9	;;
			unbold		)	_TXT_EFFECT=21	;;
			undim		)	_TXT_EFFECT=22	;;
			ununderline	)	_TXT_EFFECT=24	;;
			unblink		)	_TXT_EFFECT=25	;;
			uninvert	)	_TXT_EFFECT=27	;;
			unhidden	)	_TXT_EFFECT=28	;;
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
			unknown		)	_TXT_BG=49	;; # behaves strange in my terminal emulator, probably a "tilda" issue
			off			)	_TXT_BG=40	;;
			*			)	_TXT_BG=40	;;
		esac
		###
		_RETURN="${_CODEBLOCK_START}${_TXT_EFFECT};${_TXT_BG};${_TXT_COLOUR}${_CODEBLOCK_END}"
		echo -e "$_RETURN"
	fi
}

crit_colours() {
	local _LABEL="$1"
	local _MESSAGE="$2"
	local _OUTPUT="$(gen_colours yellow b red)$_LABEL$(gen_colours reset) $(gen_colours red b yellow)$_MESSAGE$(gen_colours reset)"
	echo -e "$_OUTPUT"
}
err_colours() {
	local _LABEL="$1"
	local _MESSAGE="$2"
	local _OUTPUT="$(gen_colours orange b black)$_LABEL$(gen_colours reset) $(gen_colours black b orange)$_MESSAGE$(gen_colours reset)"
	echo -e "$_OUTPUT"
}
warn_colours() {
	local _LABEL="$1"
	local _MESSAGE="$2"
	local _OUTPUT="$(gen_colours red n black)$_LABEL$(gen_colours reset) $(gen_colours black n red)$_MESSAGE$(gen_colours reset)"
	echo -e "$_OUTPUT"
}
info_colours() {
	local _LABEL="$1"
	local _MESSAGE="$2"
	local _OUTPUT="$(gen_colours black n white)$_LABEL$(gen_colours reset) $(gen_colours black n silver)$_MESSAGE$(gen_colours reset)"
	echo -e "$_OUTPUT"
}
dbg_colours() {
	local _LABEL="$1"
	local _MESSAGE="$2"
	local _OUTPUT="$(gen_colours black n lgreen)$_LABEL$(gen_colours reset) $(gen_colours black n green)$_MESSAGE$(gen_colours reset)"
	echo -e "$_OUTPUT"
}
