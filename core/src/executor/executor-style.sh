#!/usr/bin/env bash

export besharp_executor_sections=()

function besharp.executor.formatMessage() {
  :
}

function besharp.executor.formatSection_1() {
    echo "$(@fmt reset lightYellow)$(besharp.executor.currentSectionPrefix)====  ${1^^}  ====$(@fmt reset)" >&2
    echo '' >&2
}

function besharp.executor.formatSection_2() {
    echo "$(@fmt reset yellow)$(besharp.executor.currentSectionPrefix)==  ${1}$(@fmt reset)" >&2
    echo '' >&2
}

function besharp.executor.formatSection_3() {
    echo "$(@fmt reset lightGray)$(besharp.executor.currentSectionPrefix)==  ${1,,}$(@fmt reset)" >&2
    echo '' >&2
}

function besharp.executor.formatSection_N() {
    echo "$(@fmt reset dim lightGray)$(besharp.executor.currentSectionPrefix)==  ${1,,}$(@fmt reset)" >&2
    echo '' >&2
}

function besharp.executor.finalizeSections() {
    echo "$(@fmt lightYellow)====$(@fmt reset)" >&2
    echo "$(@fmt lightYellow)==-$(@fmt reset)" >&2
    echo "$(@fmt lightYellow)-$(@fmt reset)" >&2
}

function besharp.executor.startSection() {
    local section="${1}"

    besharp_executor_sections+=( "${section}" )

    local callback="besharp.executor.formatSection_$(besharp.executor.currentSectionLevel)"
    if ! besharp.is.callback "${callback}"; then
        callback="besharp.executor.formatSection_N"
    fi

    ${callback} "${section}"
}

function besharp.executor.stopSection() {
    echo ' ' >&2
    unset besharp_executor_sections[-1]
}

function besharp.executor.sectionsSeparator() {
    echo ' ' >&2
    echo ' ' >&2
}

function besharp.executor.currentSectionLevel() {
    echo "${#besharp_executor_sections[@]}"
}

function besharp.executor.currentSectionPrefix() {
    local lvl=${#besharp_executor_sections[@]}
    while (( lvl > 0 && --lvl )); do
        echo -n '==--'
    done
}

function besharp.executor.currentSectionTitle() {
    echo "${besharp_executor_last_section_title}" >&2
}

function besharp.executor.printSectionLines() {
    sed --unbuffered "s/^/aa$( besharp.executor.currentSectionPrefix )/g" >&2
}