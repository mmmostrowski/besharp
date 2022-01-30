#!/usr/bin/env bash

export besharp_debug_nesting_level=0
export besharp_debug_keys_column_length=0
export besharp_debugger_initialized=false

function besharp.initDebugger() {
    if ${besharp_debugger_initialized}; then
        return 0
    fi

    besharp.initializeStyles

    besharp_debugger_initialized=true
}

function besharp.debug() {
    d "${@}"
}

function d() {
    set +x

    local returnCode=0

    besharp.initDebugger

    (( ++besharp_debug_nesting_level ))

    besharp_debug_keys_column_length=0

    if [[ -z "${@}" ]]; then
        besharp.debugHeader "FUNCTION" "${FUNCNAME[1]}()"
        besharp.debugFunction "${FUNCNAME[1]}"
        besharp.debugFooter
    elif besharp.is.callback "${1}"&& ! besharp.is.variable "${1}"; then
          besharp.debugHeader "FUNCTION CALL" "${1}()"
          besharp.debugFunctionCall "${@}"
          returnCode=${?}
          besharp.debugFooter
    else
        local varName
        if (( ${#} > 1 )); then
            besharp.debugGroupStart
        fi
        for varName in "${@}"; do
            if besharp.is.indexArray "${varName}"; then
                besharp.debugHeader "INDEX ARRAY" "\${${varName}[@]}"
                besharp.debugArray "${varName}"
                besharp.debugFooter
            elif besharp.is.assocArray "${varName}"; then
                besharp.debugHeader "ASSOC ARRAY" "\${${varName}[@]}"
                besharp.debugArray "${varName}"
                besharp.debugFooter
            elif besharp.is.variable "${varName}"; then
                besharp.debugHeader "VARIABLE" "\${${varName}}"
                besharp.debugVariable "${varName}"
                besharp.debugFooter
            elif [[ -f "${varName}" ]]; then
                besharp.debugHeader "FILE" "${varName}"
                besharp.debugFile "${varName}"
                besharp.debugFooter
            elif [[ -d "${varName}" ]]; then
                besharp.debugHeader "DIRECTORY" "${varName%/}/"
                besharp.debugDir "${varName}"
                besharp.debugFooter
            else
                besharp.debugHeader "STRING"
                besharp.debugString "${varName}"
                besharp.debugFooter
            fi
        done
        if (( ${#} > 1 )); then
            besharp.debugGroupStop
        fi
    fi

    if (( --besharp_debug_nesting_level )); then
        set -x
    fi

    return ${returnCode}
}

function besharp.isDebugging() {
    [[ -n "${-//[^x]/}" ]]
}

function besharp.turnDebuggingOn() {
    set -x
}

function besharp.turnDebuggingOff() {
    set +x
}

function besharp.isDebugModeRequested() {
    [[ "${BESHARP_DEBUG:-}" == "1" ]] || [[ "${BESHARP_DEBUG:-}" == "yes" ]] || [[ "${BESHARP_DEBUG:-}" == "true" ]]
}

