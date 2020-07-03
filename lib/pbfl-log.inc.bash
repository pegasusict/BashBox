#!/bin/bash
################################################################################
## Pegasus' Linux Administration Tools #         BashFrame ##
## (C)2017-2018 Mattijs Snepvangers    #                pegasus.ict@gmail.com ##
## License: MIT                        #   Please keep my name in the credits ##
################################################################################
## LIB="Log Functions"
# VERSION=( 0 0 16 "DEV" 20200701 )
################################################################################

# mod: pbfl_logging
# txt: This script contains functions that facilitate logging messages to
#      logfile and screen

declare -agr LOG_LEVELS=( "CRITICAL" "ERROR" "WARNING" "INFO" "DEBUG" )
declare -Agr LOG_LEVELS_INV=( ["CRITICAL"]=1 ["ERROR"]=2 ["WARNING"]=3 ["INFO"]=4 ["DEBUG"]=5 )

# fun: set_verbosity
# txt: declares global constant VERBOSITY, is usually called from get_args
#      defaults to INFO
# use: set_verbosity <INT> VERBOSITY
# api: logging
function set_verbosity() {
  [[ -n $1 ]] && local _LEVEL=$1 || local _LEVEL=${LOG_LEVELS_INV["INFO"]}
  dbg_line "Setting verbosity to ${LOG_LEVELS[$_LEVEL]}"
  if [[ ${LOG_LEVELS[$_LEVEL]} ]]; then
    declare -gr VERBOSITY=$_LEVEL
    info_line "Verbosity is set to ${LOG_LEVELS[$_LEVEL]}"
  else
    declare -gr VERBOSITY=${LOG_LEVELS_INV["INFO"]}
    info_line "Verbosity defaults to INFO"
  fi
}

### loglines

# fun: crit_line MESSAGE
# txt: Passes MESSAGE on to 'log_line 1'
# use: crit_line <var> MESSAGE
# api: logging
crit_line() {
  #dbg_pause
  local _MESSAGE="$1"
  log_line 1 "$_MESSAGE"
  #dbg_restore
}

# fun: err_line MESSAGE
# txt: Passes MESSAGE on to 'log_line 2'
# use: err_line <var> MESSAGE
# api: logging
err_line() {
  #dbg_pause
  if [[ $VERBOSITY -ge ${LOG_LEVELS_INV["ERROR"]} ]]; then
    if [[ -n "$1" ]]; then
      local _MESSAGE="$1"
      log_line 2 "$_MESSAGE"
    else log_line 2 "An unknown error occurred"
    fi
  else
    err_line() { : ; }
  fi
  #dbg_restore
}

# fun: warn_line MESSAGE
# txt: Passes MESSAGE on to 'log_line ${LOG_LEVELS_INV["WARNING"]}'
# use: warn_line <var> MESSAGE
# api: logging
warn_line() {
  #dbg_pause
  if [[ $VERBOSITY -ge ${LOG_LEVELS_INV["WARNING"]} ]]; then
    local _MESSAGE="$1"
    log_line ${LOG_LEVELS_INV["WARNING"]} "$_MESSAGE"
  else
    warn_line() { : ; }
  fi
  #dbg_restore
}

# fun: info_line MESSAGE
# txt: Passes MESSAGE on to 'log_line 4'
# use: info_line <var> MESSAGE
# api: logging
info_line() {
  #dbg_pause
  if [[ $VERBOSITY -ge ${LOG_LEVELS_INV["INFO"]} ]]; then
    local _MESSAGE="$1"
    log_line ${LOG_LEVELS_INV["INFO"]} "$_MESSAGE"
  else
    info_line() { : ; }
  fi
  #dbg_restore
}

# fun: dbg_line MESSAGE
# txt: Passes MESSAGE on to 'log_line 5'
# use: dbg_line <var> MESSAGE
# api: logging
dbg_line() {
  #dbg_pause
  if [[ $VERBOSITY -ge ${LOG_LEVELS_INV["DEBUG"]} ]]; then
    local _MESSAGE="$1"
    log_line ${LOG_LEVELS_INV["DEBUG"]} "$_MESSAGE"
  else
    dbg_line() { : ; }
  fi
  #dbg_restore
}

# fun: log_line IMPORTANCE MESSAGE
# txt: Creates a nice logline and decides what to print on screen and what to
#      send to logfile by comparing VERBOSITY and IMPORTANCE.
# use: log_line <int> IMPORTANCE <str> MESSAGE
# api: logging_internal
log_line() {
  local -i _IMPORTANCE=$1; local _LABEL=""; local _LOG_HEADER=""
  local _MESSAGE="${FUNCNAME[2]}: $2"; local _CHAR="%"
  local _LOG_LINE_FILLER=""; local _SCREEN_LINE_FILLER=""
  local _SCREEN_LINE=""; local _SCREEN_OUTPUT=""; local _LOG_OUTPUT=""
  local -i _LOG_LINE_FILLER_LENGTH=0; local -i _SCREEN_LINE_FILLER_LENGTH=0
  [[ -z ${SCREEN_WIDTH} ]] && get_screen_size
  [[ -n ${_IMPORTANCE} ]] && _LABEL="$LOG_LEVELS[${_IMPORTANCE}]:"
  _LABEL.=$(dup_var " " $(var_length ${LOG_LEVELS[1]} - var_length ${_LABEL}))
  _LOG_HEADER="$(get_timestamp) % $_LABEL"
  ### generating screen output
  if (( "$_IMPORTANCE" <= "$VERBOSITY" )); then
    _SCREEN_LINE_FILLER_LENGTH=$((SCREEN_WIDTH - $(var_length ${_LOG_HEADER} ${_MESSAGE})))
    _SCREEN_LINE_FILLER=$(dup_var "$_CHAR" $_SCREEN_LINE_FILLER_LENGTH)
    _SCREEN_LINE="$_MESSAGE $_SCREEN_LINE_FILLER"
    _SCREEN_OUTPUT=$(log_colours ${_IMPORTANCE} "$_LOG_HEADER" "$_SCREEN_LINE")
    [[ $_IMPORTANCE -le 2 ]] && echo -e "$_SCREEN_OUTPUT" >&2 || echo -e "$_SCREEN_OUTPUT"
  fi
  ### generating log output
  _LOG_LINE_FILLER_LENGTH=$((LOG_WIDTH - $(var_length ${_LOG_HEADER} ${_MESSAGE})))
  _LOG_LINE_FILLER=$(dup_var "$_CHAR" $_LOG_LINE_FILLER_LENGTH)
  _LOG_OUTPUT="$_LOG_HEADER $_MESSAGE $_LOG_LINE_FILLER"
  to_log "$_LOG_OUTPUT"
}

# fun: to_log
# txt: Checks whether the log file has been created yet and whether the log
#      buffer exists. The log entry will be added to the logfile if exist,
#      otherwise it will be added to the buffer which will be created if needed.
# use: to_log LOG_ENTRY
# api: logging_internal
to_log() {
  local -r _LOG_ENTRY="${1}"
  if [[ "$LOG_FILE_CREATED" != true ]]; then
    if [[ -z "${LOG_BUFFER}" ]]; then
      declare -g LOG_BUFFER
      LOG_BUFFER="$START_TIME - $COMMAND Process started\n"
    fi
    LOG_BUFFER+="$_LOG_ENTRY\n"
  else
    to_log() {
      if [[ -n "${LOG_BUFFER}" ]]
      then
        cat "${LOG_BUFFER}" > "${LOG_FILE}"
        unset ${LOG_BUFFER}
      else
        to_log() {
          echo "${_LOG_ENTRY}" >> "${LOG_FILE}"
        }
      fi
      echo "${_LOG_ENTRY}" >> "${LOG_FILE}"
    }
  fi
}

# fun: exeqt
# txt: Executes COMMAND.
#      If COMMAND returns an error code, the output is sent to the error log.
# use: exeqt COMMAND
# api: logging internal
exeqt() {
  local _CMD    ; _CMD="$1"
  local _RESULT  ; _RESULT=$($_CMD) 2>&1
  if [[ $? > 0 ]]
  then
    err_line $_RESULT
  fi
}
