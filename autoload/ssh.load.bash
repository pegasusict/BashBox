#!/bin/env bash
################################################################################
## Pegasus' Linux Administration Tools #         BashFrame ##
## (C)2017-2020 Mattijs Snepvangers    #                pegasus.ict@gmail.com ##
## License: MIT                        #   Please keep my name in the credits ##
################################################################################
## SCRIPT_TITLE="SSH Functions AutoLoader"
## VERSION=( 0 1 0 "ALPHA" 20200701 )
################################################################################

# fun: autoload_register
# txt: registers function placeholders which will load the respective library when required
# api: pbfl::internal
autoload_register() {
  local -r LIB="ssh"
  local -ar FUNCTIONS=( "ssh_run_on" "ssh_put" "ssh_get" )

  pbfl_autoload_register ${LIB} ${FUNCTIONS[@]}
}
