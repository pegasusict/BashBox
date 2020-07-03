#!/bin/env bash
################################################################################
## Pegasus' Linux Administration Tools #         BashFrame ##
## (C)2017-2020 Mattijs Snepvangers    #                pegasus.ict@gmail.com ##
## License: MIT                        #   Please keep my name in the credits ##
################################################################################
## SCRIPT_TITLE="FileSystem Functions AutoLoader"
## VERSION=( 0 1 0 "ALPHA" 20200701 )
################################################################################

# fun: autoload_register
# txt: registers function placeholders which will load the respective library when required
# api: pbfl::internal
autoload_register() {
  local -r LIB="filesystem"
  local -ar FUNCTIONS=( "create_dir" "create_file" "create_logfile" "file_exists"
  "go_home" "purge_dir" )

    pbfl_autoload_register ${LIB} ${FUNCTIONS[@]}
}
