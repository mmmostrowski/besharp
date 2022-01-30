#!/usr/bin/env bash

function besharp.readLine() {
    local oldIfs="${IFS}"

    IFS=$'\n'
    read "${@}"
    local returnCode=${?}

    IFS="${oldIfs}"

    return ${returnCode}
}

function besharp.grepList() {
    grep "${@}" || true
}

function besharp.grepMatch() {
    grep -q "${@}"
}

