#!/usr/bin/env bash

function besharp.is.Array() {
    besharp.is.indexArray "${@}" || besharp.is.assocArray "${@}"
}

function besharp.is.indexArray() {
    local varName="${1}"

    [[ "$( declare -p "${varName}" 2> /dev/null )" =~ "declare -a" ]]
}

function besharp.is.assocArray() {
    local varName="${1}"

    [[ "$( declare -p "${varName}" 2> /dev/null )" =~ "declare -A" ]]
}

function besharp.is.variable() {
    local varName="${1}"

    declare -p "${varName}" 2> /dev/null > /dev/null
}

function besharp.is.callback() {
    local varName="${1}"

    if [[ "$(type -t "${1}" 2> /dev/null || true)" == "function" ]]; then
        return 0
    fi

    # note: we skip 'eval' internationally to work properly with debugger
    local bashKeywords="alias awk basename bash bc bind builtin caller cat cd chgrp chmod chown command cut date declare df diff dirname du echo enable export expr find grep head help kill less let ln local logout ls mapfile mkdir more mv nohup printf pwd read readarray rm rmdir sed set sh sleep sort source tail tar tee touch tr type typeset ulimit unalias uniq unset wc xargs"
    local keyword
    for keyword in ${bashKeywords}; do
        if [[ "${varName}" == "${keyword}" ]]; then
            return 0
        fi
    done

    return 1
}
