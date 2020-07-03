#!/bin/bash -p
################################################################################
# Pegasus' Linux Administration Tools  #      BashFrame #
# (C)2017-2018 Mattijs Snepvangers    #         pegasus.ict@gmail.com #
# License: MIT              #  Please keep my name in the credits #
################################################################################

################################################################################
# PROGRAM_SUITE="Pegasus' Linux Administration Tools"
# SCRIPT_TITLE="Exit Codes Script"
# MAINTAINER="Mattijs Snepvangers"
# MAINTAINER_EMAIL="pegasus.ict@gmail.com"
# VER_MAJOR=0
# VER_MINOR=0
# VER_PATCH=7
# VER_STATE="PRE-ALPHA"
# BUILD=20180710
# LICENSE="MIT"
################################################################################

### EXITCODES HOWTO
exit_codes_howto() {
  <<-EOF
    This file attempts to categorize possible error exit statuses for system program.

    Error numbers begin at EX__BASE to reduce the possibility of clashing with other exit statuses that random programs may already return.
    The meaning of the codes is approximately as follows:

    EX_USAGE    ->  The command was used incorrectly, e.g., with the wrong number of arguments, a bad flag, a bad syntax in a parameter, or whatever.
    EX_DATAERR    ->  The input data was incorrect in some way. This should only be used for user\'s data & not system files.
    EX_NOINPUT    ->  An input file (not a system file) did not exist or was not readable. This could also include errors like "No message" to a mailer (if it cared to catch it).
    EX_NOUSER    ->  The user specified does not exist. This might be used for mail addresses or remote logins.
    EX_NOHOST    ->  The host specified did not exist. This is used in mail addresses or network requests.
    EX_UNAVAILABLE  ->  A service is unavailable. This can occur if a support program or file does not exist. This can also be used as a catchall message when something you wanted to do doesn\'t work, but you don\'t know why.
    EX_SOFTWARE      ->  An internal software error has been detected. This should be limited to non-operating system related errors as possible.
    EX_OSERR    ->  An operating system error has been detected. It includes things like getuid returning a user that does not exist in the passwd file.
    EX_OSFILE    ->  Some system file (e.g., /etc/passwd, /etc/utmp, etc.) does not exist, cannot be opened, or has some sort of error (e.g., syntax error).
    EX_CANTCREAT  ->  A (user specified) output dir or file cannot be created.
    EX_IOERR    ->  An error occurred while doing I/O on some file.
    EX_TEMPFAIL    ->  temporary failure, indicating something that is not really an error. In sendmail, this means that a mailer (e.g.) could not create a connection, and the request should be reattempted later.
    EX_PROTOCOL    ->  the remote system returned something that was "not possible" during a protocol exchange.
    EX_NOPERM    ->  You did not have sufficient permission to perform the operation. This is not intended for file system problems, which should use NOINPUT or CANTCREAT, but rather for higher level permissions.
EOF
}

### DECLARING EXIT CODES
declare_exit_codes() {
  declare -ag EXIT_CODES
  EXIT_CODES[0]="EX_OK"      #  successful termination

  ### reserved exit codes (source: advanced bash scripting guide)
  EXIT_CODES[1]="EX_GEN_ERR"    #  generic error code
  EXIT_CODES[2]="EX_MISUSE"    #  Misuse of shell builtins; Missing keyword or command, or permission problem (and diff return code on a failed binary file comparison).
  ####

  ### defined by apple for C code ###
  EXIT_CODES[64]="EX_USAGE"      #  command line usage error
  EXIT_CODES[65]="EX_DATAERR"      #  data format error
  EXIT_CODES[66]="EX_NOINPUT"      #  cannot open input
  EXIT_CODES[67]="EX_NOUSER"      #  addressee unknown
  EXIT_CODES[68]="EX_NOHOST"      #  host name unknown
  EXIT_CODES[69]="EX_UNAVAILABLE"    #  service unavailable
  EXIT_CODES[70]="EX_SOFTWARE"    #  internal software error
  EXIT_CODES[71]="EX_OSERR"      #  system error (e.g., can't fork)
  EXIT_CODES[72]="EX_OSFILE"      #  critical OS file missing
  EXIT_CODES[73]="EX_CANTCREAT"    #  can't create (user) output file
  EXIT_CODES[74]="EX_IOERR"      #  input/output error
  EXIT_CODES[75]="EX_TEMPFAIL"    #  temp failure; user is invited to retry
  EXIT_CODES[76]="EX_PROTOCOL"    #  remote error in protocol
  EXIT_CODES[77]="EX_NOPERM"      #  permission denied
  EXIT_CODES[78]="EX_CONFIG"      #  configuration error
  ### end defined by apple ###

  ### thought up myself ###
  EXIT_CODES[80]="EX_USER"      #  unexpected user input.
  EXIT_CODES[81]="EX_FORK"      #  Cannot Fork
  EXIT_CODES[82]="EX_PIPE"      #  Cannot create pipe
  EXIT_CODES[83]="EX_DNS"        #  DNS error, either Host or Domain does not exist or DNS server unreachable.
  EXIT_CODES[84]="EX_FILE_WRITE"    #  File writing error so either the permissons are off or the fs is readonly
  EXIT_CODES[85]="EX_FILE_READ"    #  File reading error so the permissons must be wrong
  EXIT_CODES[86]="EX_FILE_NOTEXIST"  #  File doen not exist
  EXIT_CODES[87]="EX_DIR_WRITE"    #  Cannot write into DIR; directory permissions are wrong or fs is mounted readonly
  EXIT_CODES[88]="EX_DIR_READ"    #  Dir reading error so the permissons must be wrong
  EXIT_CODES[89]="EX_DIR_NOTEXIST"  #  Dir does not exist
  EXIT_CODES[90]="EX_HOST_TIMEOUT"  #  Timeout on connection
  ### end thought up myself

  ### reserved exit codes (source: advanced bash scripting guide)
  EXIT_CODES[126]="EX_EXEC"      #  Command invoked cannot execute; permission problem or command is not an executable
  EXIT_CODES[127]="EX_NOTFOUND"    #  command not found; possible problem with $PATH or a typo
  EXIT_CODES[128]="EX_EXIT"      #  Invalid argument to exit; exit takes only integer args in the range 0 - 255
  EXIT_CODES[130]="EX_CTRL_C"      #  Script terminated by Control-C; Control-C is fatal error signal 2, (130 = 128 + 2)
  EXIT_CODES[137]="EX_ERR_SIG9"    #  Fatal error signal 9; kill -9 $PPID $? returns 137 (128 + 9)
  EXIT_CODES[143]="EX_ERR_SIG15"    #  Fatal error signal 15; kill -15 $PPID $? returns 143 (128 + 15)
  if [[ $EXIT_CODE>255 ]]        #  Exit status out of range; exit takes only integer args in the range 0 - 255
  then
    EXIT_CODE="$EX_EXIT"
  fi
}

do_exit() {
  local _EXIT_CODE="$1"
  local _MESSAGE="$2"
  local _OUTPUT=""
  for $EXIT_CODE in "${EXIT_CODES[@]}"
  do
    if (("$_EXIT_CODE" == "$EXIT_CODE" ))
    then
      _OUTPUT="$EXIT_CODES[$_EXIT_CODE]: $_MESSAGE"
      if (( "$_EXIT_CODE" > 0 ))
      then
        exit "$_EXIT_CODE" "$_OUTPUT" >&2
      fi
    fi
  done
}

catch_exit() {
  local _CAUGHT_CODE="$1"
  local _OUTPUT=""
  for $EXIT_CODE in "${EXIT_CODES[@]}"
  do
    if (("$_CAUGHT_CODE" == "$EXIT_CODE" ))
    then
      _OUTPUT="$_CAUGHT_CODE: $EXIT_CODES[$_CAUGHT_CODE]"
      echo "$_OUTPUT"
    fi
  done
}

#######

declare_exit_codes
