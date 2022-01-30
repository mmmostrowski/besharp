#!/usr/bin/env bash


function besharp.array.clone() {
    local source="${1}"
    local target="${2}"

    unset "${target}" || true
    unset "${target}[@]" || true

    local source="${source}[@]"

    eval "${target}=( )"
    local arg
    for arg in "${!source:-}"; do
        eval "${target}+=( \"\${arg}\" )"
    done
}

