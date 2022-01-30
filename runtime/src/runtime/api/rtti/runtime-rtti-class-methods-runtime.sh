#!/usr/bin/env bash

function besharp.rtti.allMethodsOf() {
    local type="${1}"

    eval "echo \"\${besharp_oopRuntime_type_${type}_all_methods[@]:-}\""
}

function besharp.rtti.hasMethod() {
    local type="${1}"
    local method="${2}"

    eval "[[ \"\${besharp_oopRuntime_type_${type}_all_methods[${method}]+isset}\" == 'isset' ]]"
}

function besharp.rtti.isMethodAbstract() {
    local type="${1}"
    local method="${2}"

    eval "[[ \"\${besharp_oopRuntime_type_${type}_all_abstract_methods[${method}]+isset}\" == 'isset' ]]"
}

