#!/bin/env bash
################################################################################
## Pegasus' Linux Administration Tools #         BashFrame ##
## (C)2017-2020 Mattijs Snepvangers    #                pegasus.ict@gmail.com ##
## License: MIT                        #   Please keep my name in the credits ##
################################################################################
## SCRIPT_TITLE="Variable Functions AutoLoader"
## VERSION=( 0 1 0 "ALPHA" 20200701 )
################################################################################

# fun: autoload_register
# txt: registers function placeholders which will load the respective library when required
# api: pbfl::internal
autoload_register() {
  local -r LIB="vars"
  local -ar FUNCTIONS=( "create_var" "dup_var" "var_length" "key_exists" "value_exists"
    "str_to_lower" "str_to_upper" )

  pbfl_autoload_register ${LIB} ${FUNCTIONS[@]}
}
