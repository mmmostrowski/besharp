#!/usr/bin/env bash

function besharp.info() {
    besharp.formatMessage INFO "bold green" "lightGreen" "${@}"
}

function besharp.warning() {
    besharp.formatMessage WARNING "bold yellow" "lightYellow" "${@}" >&2
}

