#!/usr/bin/env bash

function besharp.fastCall.toArrayOfTokens() {
    local arrName="${1}"
    shift 1

    echo -n "${arrName}=( " > "${besharp_io_buffer_file}"
    "${@}" >> "${besharp_io_buffer_file}"
    echo " )" >> "${besharp_io_buffer_file}"
    source "${besharp_io_buffer_file}"
}

function besharp.fastCall.toVar() {
    local varName="${1}"
    shift 1

    echo "IFS='' read -r -d '' ${varName} <<\"EOFEOFF123f43tdsxx\"" > "${besharp_io_buffer_file}"
    "${@}" >> "${besharp_io_buffer_file}"
    echo "EOFEOFF123f43tdsxx" >> "${besharp_io_buffer_file}"
    source "${besharp_io_buffer_file}" || true
}

function besharp.fastCall.toVarSingleToken() {
    local varName="${1}"
    shift 1

    echo -n export "${varName}=" > "${besharp_io_buffer_file}"
    "${@}" >> "${besharp_io_buffer_file}"
    source "${besharp_io_buffer_file}"
}
