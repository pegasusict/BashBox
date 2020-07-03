#!/bin/env bash
###############################################################################
## Pegasus' Linux Administration Tools #        BashFrame ##
## (C)2017-2020 Mattijs Snepvangers    #               pegasus.ict@gmail.com ##
## License: MIT                        #  Please keep my name in the credits ##
###############################################################################
## SCRIPT_TITLE="AutoLoader"
## VERSION=( 0 1 0 "DEV" 20200701 )
###############################################################################

# fun: pbfl_autoload_register
# txt: registers function placeholders which will load the respective library
#       when required
# api: pbfl::internal
function pbfl_autoload_register() {
  local -r  _LIB="$1"
  local -ar _FUNCTIONS=( $2[@] )

  for _FUNCTION in $_FUNCTIONS; do
    eval "${_FUNCTION}() { import_lib ${_LIB} ; ${_FUNCTION} \$@; }"
  done
}

# get source directory
SOURCE="${BASH_SOURCE[0]}"
while [[ -h "$SOURCE" ]]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
[[ $DIR != */ ]] && DIR="${DIR}/"

source "${DIR}autoload/*.load.bash"
