#!/bin/env bash
################################################################################
## Pegasus' Linux Administration Tools #         BashFrame ##
## (C)2017-2020 Mattijs Snepvangers    #                pegasus.ict@gmail.com ##
## License: MIT                        #   Please keep my name in the credits ##
################################################################################
## SCRIPT_TITLE="Log Functions AutoLoader"
## VERSION=( 0 1 0 "ALPHA" 20200701 )
################################################################################

# fun: autoload_register
# txt: registers function placeholders which will load the respective library when required
# api: pbfl::internal
autoload_register() {
  local -r LIB="log"
  local -ar FUNCTIONS=( "set_verbosity" "crit_line" "err_line" "warn_line"
  "info_line" "dbg_line" "log_line" "to_log" "exeqt" )

  pbfl_autoload_register ${LIB} ${FUNCTIONS[@]}
}
