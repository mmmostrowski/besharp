#!/usr/bin/env bash

export besharp_error_default_message=

function besharp.error() {
    set +x
    besharp.formatMessage ERROR "bold red" "lightRed" "${@}" >&2
    besharp.debugTrace 2

    if (( BASHPID != besharp_main_pid )); then
        kill  ${besharp_main_pid} 2> /dev/null || true
        kill  ${BASHPID} 2> /dev/null || true
    fi

    besharp.error.disableHandling

    exit 1
    return 1
}

function besharp.error.enableHandling() {
      local customMessage="${1}"

      besharp_error_default_message="${1}"

      trap "responseCode=\$?; besharp.shutdown; if (( \$responseCode != 0 )); then besharp.error \${besharp_error_default_message:-Unexpected command failure}; fi" EXIT
      trap "besharp.shutdown; exit 1" INT
}

function besharp.error.disableHandling() {
      trap "" EXIT
}

