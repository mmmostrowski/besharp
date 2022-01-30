#!/usr/bin/env bash

function besharp.debugString() {
    local string="${1}"

    besharp.debugLines "${string}"
}

function besharp.debugVariable() {
    local varName="${1}"

    besharp.debugLines "${!varName:-}"
}

function besharp.debugFile() {
    local varName="${1}"

    besharp.debugLines "$( cat "${varName}" )"
}

function besharp.debugFunctionCall() {
    local returnCode
    set -x
    "${@}"
    returnCode=${?}
    set +x
    return ${returnCode}
}

function besharp.debugFunction() {
    local func="${1}"

    local token
    local toVerify=false
    for token in $( declare -f "${func}" ); do
        if [[ "${token}" == "local" ]]; then
            toVerify=true
            continue
        fi

        if $toVerify; then
            toVerify=false
            local potentialVariableNameArr=( ${token//=/ } )
            local varName="${potentialVariableNameArr[0]}"
            if besharp.is.Array "${varName}"; then
                eval "local value=\${${varName}[*]}"
                besharp.debugKeyedValue "local \$${varName}" "( ${value} )"
            elif besharp.is.variable "${varName}"; then
                besharp.debugKeyedValue "local \$${varName}" "${!varName}"
            fi
        fi
    done

    besharp_debug_keys_column_length=0

    besharp.debugLines "$( besharp.generateDebugTrace 4 )"
}

function besharp.debugArray() {
    local varName="${1}"

    local keys=()
    eval "for key in \${!${varName}[@]}; do keys+=( \$key ); done"
    local key
    local value
    for key in "${keys[@]}"; do
        key="${key}"
        eval "value=\"\${${varName}[\${key}]}\""
        besharp.debugKeyedValue "${key}" "${value}"
    done
}

function besharp.debugKeyedValue() {
    local key="${1}"
    local value="${2}"

    local line
    local firstLine=true
    while read line; do
        if $firstLine; then
            firstLine=false
            besharp.debugTaggedLine "${key}" "${line}"
        else
            besharp.debugLine "${line}"
        fi
    done<<<"${value}"
}

function besharp.debugDir() {
    local dir="${1}"

    local file
    for file in $( ls "${dir}" ); do
        file="${dir%/}/${file}"

        local linkFlag=""
        if [[ -L "${file}" ]]; then
            linkFlag="L"
        fi

        if [[ -d "${file}" ]]; then
            besharp.debugTaggedLine "${linkFlag}d" "${file}"
            besharp.debugDir "${file}"
        elif [[ -f "${file}" ]]; then
            besharp.debugTaggedLine "${linkFlag}f" "${file}"
        else
            besharp.debugTaggedLine "?" "${file}"
        fi
    done
}

