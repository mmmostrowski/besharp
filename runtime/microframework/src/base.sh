#!/usr/bin/env bash

export besharp_main_pid=${BASHPID}
export besharp_loglevel=info # debug error

function besharp.microframework.boostrap() {
    local scopeName="${1:-besharp microframework}"

    if besharp.isDebugModeRequested; then
        besharp.turnDebuggingOn
    fi

    besharp.polymorphism.initialize
    besharp.error.enableHandling "Unexpected command failure at the ${scopeName} scope"
}

function besharp.isLoggingError() {
    [[ "${besharp_loglevel}" == 'info' ]] || [[ "${besharp_loglevel}" == 'debug' ]] || [[ "${besharp_loglevel}" == 'error' ]]
}

function besharp.isLoggingInfo() {
    [[ "${besharp_loglevel}" == 'info' ]] || [[ "${besharp_loglevel}" == 'debug' ]]
}

function besharp.isLoggingDebug() {
    [[ "${besharp_loglevel}" == 'debug' ]]
}

