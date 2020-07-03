#!/bin/env bash
################################################################################
## Pegasus' Linux Administration Tools #         BashFrame ##
## (C)2017-2020 Mattijs Snepvangers    #                pegasus.ict@gmail.com ##
## License: MIT                        #   Please keep my name in the credits ##
################################################################################
## SCRIPT_TITLE="LXC Functions AutoLoader"
## VERSION=( 0 1 0 "ALPHA" 20200701 )
################################################################################

# fun: autoload_register
# txt: registers function placeholders which will load the respective library when required
# api: pbfl::internal
autoload_register() {
  local -r LIB="lxc"
  local -ar FUNCTIONS=( "lxc_rename" "check_cont_name" "create_cont" "start_cont"
    "stop_cont" "list_cont" "run_post_install" "run_in_container"
    "put_in_container" "pull_from_container" )

  pbfl_autoload_register ${LIB} ${FUNCTIONS[@]}
}
