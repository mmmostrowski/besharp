#!/usr/bin/env bash

function @() {
    if (( ${#@} == 0 )); then
        export besharp_runtime_reset_iteration=1
    else
        @echo "${@}"
    fi
}

function @true() {
    "${@}"

    [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]}" == 'true' ]]
}

function @true__develop() {
    local value
    @let value = "${@}"
    [[ "${value}" == "true" ]]
}

function @false() {
    "${@}"

    [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]}" == 'false' ]]
}

function @false__develop() {
    local value
    @let value = "${@}"
    [[ "${value}" != "true" ]]
}

function @not() {
    "${@}"

    if [[ "${besharp_rcrvs[ besharp_rcsl + 1 ]}" == 'true' ]]; then
        besharp_rcrvs[ besharp_rcsl + 1 ]="false"
    else
        besharp_rcrvs[ besharp_rcsl + 1 ]="true"
    fi
}

function @not__develop() {
    local value
    @let value = "${@}"
    if $value; then
        besharp.runtime.storeReturnValueOnStackAtDepth1 false
    else
        besharp.runtime.storeReturnValueOnStackAtDepth1 true
    fi
}

function @echo() {

    local flags=""
    while [[ "${1#\-}" != "${1}" ]]; do
      if [[ "${1}" == "-n" ]]; then
          flags="${flags} -n"
          shift 1
          continue
      elif [[ "${1}" == "-e" ]]; then
          flags="${flags} -e"
          shift 1
          continue
      elif [[ "${1}" == "-E" ]]; then
          flags="${flags} -E"
          shift 1
          continue
      fi
      break
    done

    local result=""
    if [[ "${1}" == "@of" ]] && [[ "${2+isset}" == 'isset' ]]; then
        shift 1
        # field
        @let result = "${@}"
    else
        @let result = "${@}"
    fi

    echo ${flags} "${result}"
}
