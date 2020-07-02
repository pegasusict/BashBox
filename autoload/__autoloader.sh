#!/bin/env bash
###############################################################################
## Pegasus' Linux Administration Tools #      Pegasus' Bash Function Library ##
## (C)2017-2020 Mattijs Snepvangers    #               pegasus.ict@gmail.com ##
## License: MIT                        #  Please keep my name in the credits ##
###############################################################################

###############################################################################
### PROGRAM_SUITE="Pegasus' Linux Administration Tools"
### SCRIPT_TITLE="AutoLoader"
### MAINTAINER="Mattijs Snepvangers"
### MAINTAINER_EMAIL="pegasus.ict@gmail.com"
### VER_MAJOR=0
### VER_MINOR=1
### VER_PATCH=0
### VER_STATE="DEV"
### BUILD=20200701
### LICENSE="MIT"
################################################################################

# fun: pbfl_autoload_register
# txt: registers function placeholders which will load the respective library when required
# api: pbfl::internal
function pbfl_autoload_register() {
  local -r  _LIB="$1"
  local -ar _FUNCTIONS=( $2[@] )

  for _FUNCTION in $_FUNCTIONS; do
    eval "${_FUNCTION}() { import_lib ${_LIB} ; ${_FUNCTION} \$@; }"
  done
}

# # # # # # # # # # # #
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
[[ $DIR != */ ]] && DIR="${DIR}/"

source ${DIR}*.bash