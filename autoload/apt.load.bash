#!/bin/env bash
################################################################################
## Pegasus' Linux Administration Tools #         BashFrame ##
## (C)2017-2020 Mattijs Snepvangers    #                pegasus.ict@gmail.com ##
## License: MIT                        #   Please keep my name in the credits ##
################################################################################
## SCRIPT_TITLE="Apt Functions AutoLoader"
## VERSION=( 0 1 0 "ALPHA" 20200701 )
################################################################################

# fun: autoload_register
# txt: registers function placeholders which will load the respective library when required
# api: pbfl::internal
function autoload_register() {
  local -r LIB="apt"
  local -ar FUNCTIONS=( "apt_cmd" "apt_cmd_silent" "add_ppa_key" "apt_inst_with_recs"
 "apt_inst_no_recs" "apt_update" "apt_upgrade" "apt_remove" "apt_uninstall" "apt_clean"
 "apt_fix_deps" "install_pkg" "clean_sources" "apt_cycle" "apt_uninstall" )

  pbfl_autoload_register ${LIB} ${FUNCTIONS[@]}
}
