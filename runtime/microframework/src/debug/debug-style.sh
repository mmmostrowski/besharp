#!/usr/bin/env bash

export besharp_debugger_fmt_currently_in_group=false

function besharp.initializeStyles() {
    export besharp_debugger_fmt_resetStyle="$( @fmt reset )"
    export besharp_debugger_fmt_headerAStyle="$( @fmt reset )$( @fmt bold black bgDarkGray )"
    export besharp_debugger_fmt_headerBStyle="$( @fmt reset )$( @fmt bold lightYellow bgDarkGray )"
    export besharp_debugger_fmt_headerCStyle="$( @fmt reset )$( @fmt darkGray )"
    export besharp_debugger_fmt_headerDStyle="$( @fmt reset )$( @fmt darkGray bgDarkGray )"
    export besharp_debugger_fmt_blockStyle="$( @fmt reset )$( @fmt white bgDarkGray )"
}

function besharp.debugLines() {
    local input="${1}"

    local line
    local lineNum=0
    while besharp.readLine line; do
        local lineNumStr=$(( ++lineNum ))
        if (( lineNum < 10 )); then
            lineNumStr="0${lineNumStr}"
        fi
        besharp.debugTaggedLine "${lineNumStr}" "${line}"
    done<<<"${input}"
}

function besharp.debugHeader() {
    local headerA="${1}"
    local headerB="${2:-}"

    local linen="${BASH_LINENO[1]}"
    local src="${BASH_SOURCE[2]}"

    local source=" @ ${src//\/\//\/}:${linen}"

    if ! $besharp_debugger_fmt_currently_in_group; then
        echo '' >&2
    fi

    if [[ -z "${headerB}" ]]; then
        echo "${besharp_debugger_fmt_blockStyle}$(besharp.debugIndent)/ ${besharp_debugger_fmt_headerAStyle}${headerA}   ${besharp_debugger_fmt_headerCStyle}${source} ${besharp_debugger_fmt_resetStyle}" >&2
    else
        echo "${besharp_debugger_fmt_blockStyle}$(besharp.debugIndent)/ ${besharp_debugger_fmt_headerAStyle}${headerA} ${besharp_debugger_fmt_headerBStyle}${headerB}${besharp_debugger_fmt_headerAStyle}  ${besharp_debugger_fmt_headerCStyle}${source} ${besharp_debugger_fmt_resetStyle}" >&2
    fi
}

function besharp.debugFooter() {
    echo -n "${besharp_debugger_fmt_blockStyle}$(besharp.debugIndent)\\${besharp_debugger_fmt_resetStyle}" >&2
    while (( besharp_debug_keys_column_length > 0 )) && (( --besharp_debug_keys_column_length )); do
        echo -n "${besharp_debugger_fmt_blockStyle}_${besharp_debugger_fmt_resetStyle}" >&2
    done
    echo "${besharp_debugger_fmt_blockStyle}/${besharp_debugger_fmt_resetStyle}" >&2

    if ! $besharp_debugger_fmt_currently_in_group; then
        echo '' >&2
    fi
}

function besharp.debugLine() {
    echo "${besharp_debugger_fmt_blockStyle}$(besharp.debugIndent)|${besharp_debugger_fmt_resetStyle} ${*}" >&2
}

function besharp.debugSeparator() {
    local size="${1:-2}"

    if (( size <= 0 )); then
        return
    fi

    echo -n "${besharp_debugger_fmt_blockStyle}$(besharp.debugIndent)"
    while (( size-- )); do
        echo -n "-" >&2
    done
    echo "${besharp_debugger_fmt_resetStyle}" >&2
}

function besharp.debugGroupStart() {
    echo "" >&2
    echo "${besharp_debugger_fmt_blockStyle}/==\\${besharp_debugger_fmt_resetStyle}" >&2

    besharp_debugger_fmt_currently_in_group=true
}

function besharp.debugGroupStop() {
    echo "${besharp_debugger_fmt_blockStyle}\==/${besharp_debugger_fmt_resetStyle}" >&2
    echo "" >&2
    echo "" >&2

    besharp_debugger_fmt_currently_in_group=false
}

function besharp.debugTaggedLine() {
    local tag="${1}"
    shift 1

    if (( ${#tag} + 3 > besharp_debug_keys_column_length )); then
        besharp_debug_keys_column_length=$(( ${#tag} + 3 ))
    fi

    echo "${besharp_debugger_fmt_blockStyle}$(besharp.debugIndent)| ${tag} |${besharp_debugger_fmt_resetStyle} ${*}" >&2
}

function besharp.debugIndent() {
    local level="${besharp_debug_nesting_level}"
    if (( level == 0 )); then
        return
    fi

    if $besharp_debugger_fmt_currently_in_group; then
        echo -n '| '
    fi

    while (( --level )); do
        echo -n "# "
    done
}

