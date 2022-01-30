#!/usr/bin/env bash

function besharp.rtti.methodsOf() {
    local type="${1}"

    eval "echo \"\${besharp_oop_type_${type}_methods[@]:-}\""
}

function besharp.rtti.hasDirectMethod() {
    local type="${1}"
    local method="${2}"

    eval "[[ \"\${besharp_oop_type_${type}_methods['${method}']+isset}\" == 'isset' ]]"
}

function besharp.rtti.constructorOf() {
    local type="${1}"

    echo "${type}"
}

