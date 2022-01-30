#!/usr/bin/env bash

function besharp.rtti.types() {
    echo "${besharp_oop_types[@]}"
}

function besharp.rtti.typeExists() {
    local type="${1}"

    [[ "${besharp_oop_types[${type}]+isset}" == 'isset' ]]
}

function besharp.rtti.isInternal() {
    local type="${1}"

    [[ "${besharp_oop_type_internal[${type}]+isset}" == 'isset' ]]
}

