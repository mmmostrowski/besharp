#!/usr/bin/env bash

function besharp.rtti.classes() {
    echo "${besharp_oop_classes[@]}"
}

function besharp.rtti.classExists() {
    local type="${1}"

    [[ "${besharp_oop_classes[${type}]+isset}" == 'isset' ]]
}

function besharp.rtti.isAbstractClass() {
    local type="${1}"

    [[ "${besharp_oop_type_abstract[${type}]+isset}" == 'isset' ]]
}

function besharp.rtti.allUserClasses() {
    local type=''
    for type in ${besharp_oop_classes[@]}; do
        if ! besharp.rtti.isInternal "${type}"; then
            echo "${type}"
        fi
    done
}

function besharp.rtti.parentOf() {
    local type="${1}"

    echo "${besharp_oop_type_parent[${type}]:-}"
}

function besharp.rtti.parentsOf() {
    local type="${1}"

    while [[ -n "${type}" ]]; do
        type="${besharp_oop_type_parent[${type}]:-}"
        echo "${type}"
    done
}

function besharp.rtti.isParentOf() {
    local type="${1}"
    local potentialParent="${2}"

    [[ "${besharp_oop_type_parent[${type}]:-}" == "${potentialParent}" ]]
}
