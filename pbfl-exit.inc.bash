#!/bin/bash -p
############################################################################
# Pegasus' Linux Administration Tools #		Pegasus' Bash Function Library #
# (C)2017-2018 Mattijs Snepvangers	  #				 pegasus.ict@gmail.com #
# License: MIT						  #	Please keep my name in the credits #
############################################################################

#########################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools"	#
# SCRIPT_TITLE="Exit Codes Script"						#
# MAINTAINER="Mattijs Snepvangers"						#
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"				#
# VERSION_MAJOR=0										#
# VERSION_MINOR=0										#
# VERSION_PATCH=0										#
# VERSION_STATE="PRE-ALPHA"								#
# VERSION_BUILD=20180425								#
# LICENSE="MIT"											#
#########################################################


### EXITCODES HOWTO
howto=<<-EOF
		This file attempts to categorize possible error exit statuses for system program.

		Error numbers begin at EX__BASE to reduce the possibility of clashing with other exit statuses that random programs may already return.
		The meaning of the codes is approximately as follows:

		EX_USAGE		->	The command was used incorrectly, e.g., with the wrong number of arguments, a bad flag, a bad syntax in a parameter, or whatever.
		EX_USER			->	Something went wrong during user interaction, most likely inexpected input from user.
		EX_DATAERR		->	The input data was incorrect in some way. This should only be used for user\'s data & not system files.
		EX_NOINPUT		->	An input file (not a system file) did not exist or was not readable. This could also include errors like "No message" to a mailer (if it cared to catch it).
		EX_NOUSER		->	The user specified does not exist. This might be used for mail addresses or remote logins.
		EX_NOHOST		->	The host specified did not exist. This is used in mail addresses or network requests.
		EX_SVC_UNAVAIL	->	A service is unavailable. This can occur if a support program or file does not exist. This can also be used as a catchall message when something you wanted to do doesn\'t work, but you don\'t know why.
		EX_SW			->	An internal software error has been detected. This should be limited to non-operating system related errors as possible.
		EX_OSERR		->	An operating system error has been detected. It includes things like getuid returning a user that does not exist in the passwd file.
		EX_FORK			->	Cannot Fork
		EX_PIPE			->	Cannot create pipe
		EX_OSFILE		->	Some system file (e.g., /etc/passwd, /etc/utmp, etc.) does not exist, cannot be opened, or has some sort of error (e.g., syntax error).
		EX_CANTCREAT	->	A (user specified) output dir or file cannot be created.
		EX_IOERR		->	An error occurred while doing I/O on some file.
		EX_TEMPFAIL		->	temporary failure, indicating something that is not really an error. In sendmail, this means that a mailer (e.g.) could not create a connection, and the request should be reattempted later.
		EX_PROTOCOL		->	the remote system returned something that was "not possible" during a protocol exchange.
		EX_NOPERM		->	You did not have sufficient permission to perform the operation. This is not intended for file system problems, which should use NOINPUT or CANTCREAT, but rather for higher level permissions.
		EX_DNS			->	DNS error, either Host or Domain does not exist or DNS server unreachable.
		EX_FILE_WRITE	->	File writing error so either the permissons are off or the fs is readonly
		EX_FILE_READ	->	File reading error so the permissons must be wrong
		EX_FILE_NOTEXIST->	File doen not exist
		EX_DIR_WRITE	->	Cannot write into DIR; directory permissions are wrong or fs is mounted readonly
		EX_DIR_READ		->	Dir reading error so the permissons must be wrong
		EX_DIR_NOTEXIST	->	Dir does not exist
EOF

declare -gr EX_OK=0				#	successful termination

declare -gr EX_GEN_ERR=1		#	generic error code

declare -gr EX__BASE=64			#	base value for error messages 

declare -gr EX_USAGE=64			#	command line usage error 
declare -gr EX_DATAERR=65		#	data format error 
declare -gr EX_NOINPUT=66		#	cannot open input 
declare -gr EX_NOUSER=67		#	addressee unknown 
declare -gr EX_NOHOST=68		#	host name unknown 
declare -gr EX_UNAVAILABLE=69	#	service unavailable 
declare -gr EX_SOFTWARE=70		#	internal software error 
declare -gr EX_OSERR=71			#	system error (e.g., can't fork) 
declare -gr EX_OSFILE=72		#	critical OS file missing 
declare -gr EX_CANTCREAT=73		#	can't create (user) output file 
declare -gr EX_IOERR=74			#	input/output error 
declare -gr EX_TEMPFAIL=75		#	temp failure; user is invited to retry 
declare -gr EX_PROTOCOL=76		#	remote error in protocol 
declare -gr EX_NOPERM=77		#	permission denied 
declare -gr EX_CONFIG=78		#	configuration error 

declare -gr EX__MAX=78			#	maximum listed value 


Code	Meaning														Example				Comments
1		Catchall for general errors									let "var1 = 1/0"	Miscellaneous errors, such as "divide by zero" and other impermissible operations
2		Misuse of shell builtins (according to Bash documentation)	empty_function() {}	Missing keyword or command, or permission problem (and diff return code on a failed binary file comparison).
126		Command invoked cannot execute								/dev/null	Permission problem or command is not an executable
127		"command not found"											illegal_command	Possible problem with $PATH or a typo
128		Invalid argument to exit									exit 3.14159	exit takes only integer args in the range 0 - 255 (see first footnote)
128+n	Fatal error signal "n"										kill -9 $PPID of script	$? returns 137 (128 + 9)
130		Script terminated by Control-C								Ctl-C	Control-C is fatal error signal 2, (130 = 128 + 2, see above)
255*	Exit status out of range									exit -1	exit takes only integer args in the range 0 - 255
